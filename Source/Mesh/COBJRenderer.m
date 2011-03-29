//
//  COBJRenderer.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "COBJRenderer.h"

#import "CVertexBuffer.h"
#import "CVertexBufferReference.h"
#import "COpenGLAssetLibrary.h"
#import "CProgram.h"
#import "Color_OpenGLExtensions.h"
#import "CTexture.h"
#import "CImageTextureLoader.h"
#import "CMaterial.h"
#import "CRenderer_Extensions.h"
#import "CMesh.h"
#import "CMeshLoader.h"
#import "CGeometry.h"
#import "CVertexArrayBuffer.h"
#import "CLight.h"

@interface COBJRenderer ()
@property (readwrite, nonatomic, retain) CMesh *mesh;
@property (readwrite, nonatomic, retain) CProgram *lightingProgram;
@end

@implementation COBJRenderer

@synthesize light;
@synthesize defaultMaterial;

@synthesize mesh;
@synthesize lightingProgram;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        light = [[CLight alloc] init];
        light.position = (Vector4){ 1, 1, 1, 0 };
        defaultMaterial = [[CMaterial alloc] init];
        
        CMeshLoader *theLoader = [[[CMeshLoader alloc] init] autorelease];
		NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"Skull2" withExtension:@"model.plist"];
        self.mesh = [theLoader loadMeshWithURL:theURL error:NULL];
        NSLog(@"MESH: %@", self.mesh);
        
        self.lightingProgram = [[[CProgram alloc] initWithName:@"Lighting" attributeNames:[NSArray arrayWithObjects:@"a_position", @"a_normal", NULL] uniformNames:[NSArray arrayWithObjects:@"u_modelViewMatrix", @"u_projectionMatrix", @"u_LightSource", @"u_LightModel", NULL]] autorelease];
		}
	return(self);
	}

- (void)dealloc
    {
    [light release];
    light = NULL;
    
    [defaultMaterial release];
    defaultMaterial = NULL;
    
    [mesh release];
    mesh = NULL;
    
    [lightingProgram release];
    lightingProgram = NULL;
    //
    [super dealloc];
    }

- (void)render
    {
    AssertOpenGLNoError_();

	Vector3 P1 = self.mesh.p1;
	Vector3 P2 = self.mesh.p2;

	GLfloat theScale = 1.0 / Vector3Length((Vector3){ fabs(P1.x - P2.x), fabs(P1.y - P2.y), fabs(P1.z - P2.z) }); 

    Matrix4 theTransform = Matrix4Scale(self.projectionTransform, theScale, theScale, theScale);

    [self drawAxes:theTransform];
    
	Vector3 theCenter = self.mesh.center;
	theTransform = Matrix4Concat(Matrix4MakeTranslation(-theCenter.x, -theCenter.y, -theCenter.z), theTransform);

    [self drawBoundingBox:theTransform v1:P1 v2:P2];

	// #### Use shader program
	CProgram *theProgram = self.lightingProgram;
	glUseProgram(theProgram.name);

    GLuint theUniform = 0;

    // #### Update transform uniform
    theUniform = [theProgram uniformIndexForName:@"u_modelViewMatrix"];
    glUniformMatrix4fv(theUniform, 1, NO, &theTransform.m00);

    theUniform = [theProgram uniformIndexForName:@"u_projectionMatrix"];
    glUniformMatrix4fv(theUniform, 1, NO, &Matrix4Identity.m00);

    AssertOpenGLNoError_();

    // #### Light sources
    theUniform = [theProgram uniformIndexForName:@"u_LightSource.ambient"];
    Color4f theColor = self.light.ambientColor;
    glUniform4fv(theUniform, 4, &theColor.r);

    theUniform = [theProgram uniformIndexForName:@"u_LightSource.diffuse"];
    theColor = self.light.diffuseColor;
    glUniform4fv(theUniform, 4, &theColor.r);

    theUniform = [theProgram uniformIndexForName:@"u_LightSource.specular"];
    theColor = self.light.specularColor;
    glUniform4fv(theUniform, 4, &theColor.r);

    theUniform = [theProgram uniformIndexForName:@"u_LightSource.position"];
    Vector4 theVector = self.light.position;
    glUniform4fv(theUniform, 4, &theVector.x);

    theUniform = [theProgram uniformIndexForName:@"u_LightSource.halfVector"];
    glUniform4f(theUniform, 0, 0.5, 0.5, 0);

    // #### Light model
    theUniform = [theProgram uniformIndexForName:@"u_LightModel.ambient"];
    glUniform4f(theUniform, 0.2, 0.2, 0.2, 1.0);
    
    // #### Material
    CMaterial *theMaterial = self.defaultMaterial;
    
    theUniform = [theProgram uniformIndexForName:@"u_FrontMaterial.ambient"];
    theColor = theMaterial.ambientColor;
    glUniform4fv(theUniform, 4, &theColor.r);

    theUniform = [theProgram uniformIndexForName:@"u_FrontMaterial.diffuse"];
    theColor = theMaterial.diffuseColor;
    glUniform4fv(theUniform, 4, &theColor.r);

    theUniform = [theProgram uniformIndexForName:@"u_FrontMaterial.specular"];
    theColor = theMaterial.specularColor;
    glUniform4fv(theUniform, 4, &theColor.r);

    theUniform = [theProgram uniformIndexForName:@"u_FrontMaterial.shininess"];
    glUniform1f(theUniform, theMaterial.shininess);    

    // #### Now render each geometry in mesh.
	for (CGeometry *theGeometry in self.mesh.geometries)
		{
        [theGeometry.vertexArrayBuffer bind];
        
        if (theGeometry.vertexArrayBuffer == NULL || theGeometry.vertexArrayBuffer.populated == NO)
            {
            // Update position attribute
            NSAssert(theGeometry.positions != NULL, @"No positions.");
            GLuint thePositionsAttributeIndex = [theProgram attributeIndexForName:@"a_position"];        
            [theGeometry.positions use:thePositionsAttributeIndex];
            glEnableVertexAttribArray(thePositionsAttributeIndex);

            // Update normal attribute
            NSAssert(theGeometry.normals != NULL, @"No normals.");
            GLuint theNormalsAttributeIndex = [theProgram attributeIndexForName:@"a_normal"];        
            [theGeometry.normals use:theNormalsAttributeIndex];
            glEnableVertexAttribArray(theNormalsAttributeIndex);
            
            theGeometry.vertexArrayBuffer.populated = YES;

            if (theGeometry.indices != NULL)
                {
                [theGeometry.indices bind];
                }
            }

		AssertOpenGLNoError_();

        // Validate program before drawing. This is a good check, but only really necessary in a debug build. DEBUG macro must be defined in your debug configurations if that's not already the case.
        #if defined(DEBUG)
            NSError *theError = NULL;
            if ([theProgram validate:&theError] == NO)
                {
                NSLog(@"Failed to validate program: %@", theError);
                return;
                }
        #endif

        glCullFace(GL_BACK);
        glEnable(GL_CULL_FACE);

        if (theGeometry.indices == NULL)
            {
            glDrawArrays(GL_TRIANGLES, 0, theGeometry.positions.rowCount);
            }
        else
            {
            glDrawElements(GL_TRIANGLES, theGeometry.indices.rowCount, GL_UNSIGNED_SHORT, 0);
            }
		}

    #if TARGET_OS_IPHONE
    glBindVertexArrayOES(0);
    #endif /* TARGET_OS_IPHONE */
    }


@end
