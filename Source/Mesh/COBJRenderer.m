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
#import "CCamera.h"

@interface COBJRenderer ()
@property (readwrite, nonatomic, retain) CProgram *lightingProgram;
@end

@implementation COBJRenderer

@synthesize camera;
@synthesize light;
@synthesize defaultMaterial;
@synthesize modelTransform;

@synthesize mesh;
@synthesize lightingProgram;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        camera = [[CCamera alloc] init];
        camera.position = (Vector4){ .x = 0, .y = 0, .z = -10 };
        
        
        light = [[CLight alloc] init];
        light.position = (Vector4){ 1, 1, 1, 0 };
        defaultMaterial = [[CMaterial alloc] init];
        modelTransform = Matrix4Identity;
                
        self.lightingProgram = [[[CProgram alloc] initWithName:@"Lighting" attributeNames:[NSArray arrayWithObjects:@"a_position", @"a_normal", NULL] uniformNames:[NSArray arrayWithObjects:@"u_modelViewMatrix", @"u_projectionMatrix", @"u_lightSource", @"u_lightModel", NULL]] autorelease];

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

- (void)prerender
    {
    [super prerender];

    self.light.position = self.camera.position;    


//    Matrix4 theModelTransform = self.modelTransform;

//    self.modelTransform = Matrix4Identity;
    self.projectionTransform = Matrix4Identity;
    Vector4 theCameraVector = self.camera.position;
    
    Matrix4 theCameraTransform = Matrix4MakeTranslation(theCameraVector.x, theCameraVector.y, theCameraVector.z);
    Matrix4 theOrthoTransform = Matrix4Perspective(90, 1.0, 0.1, 100);
    self.projectionTransform = Matrix4Concat(theCameraTransform, theOrthoTransform);

    

    }

- (void)render
    {
    AssertOpenGLNoError_();
    
    

    Matrix4 theModelTransform = modelTransform;
    Matrix4 theProjectionTransform = self.projectionTransform;

    [self drawAxes:theModelTransform];
    
	Vector3 P1 = self.mesh.p1;
	Vector3 P2 = self.mesh.p2;


	Vector3 theCenter = self.mesh.center;
	theModelTransform = Matrix4Concat(Matrix4MakeTranslation(-theCenter.x, -theCenter.y, -theCenter.z), theModelTransform);


    [self drawBoundingBox:theModelTransform v1:P1 v2:P2];

	// #### Use shader program
	CProgram *theProgram = self.lightingProgram;
	glUseProgram(theProgram.name);

    GLuint theUniform = 0;

    // #### Update transform uniform
    theUniform = [theProgram uniformIndexForName:@"u_modelViewMatrix"];
    glUniformMatrix4fv(theUniform, 1, NO, &theModelTransform.m[0][0]);

    theUniform = [theProgram uniformIndexForName:@"u_projectionMatrix"];
    glUniformMatrix4fv(theUniform, 1, NO, &theProjectionTransform.m[0][0]);

    AssertOpenGLNoError_();

    // #### Light sources
    theUniform = [theProgram uniformIndexForName:@"u_lightSource.ambient"];
    if (theUniform != 0)
        {
        Color4f theColor = self.light.ambientColor;
        glUniform4fv(theUniform, 4, &theColor.r);
        }

    theUniform = [theProgram uniformIndexForName:@"u_lightSource.diffuse"];
    if (theUniform != 0)
        {
        Color4f theColor = self.light.diffuseColor;
        glUniform4fv(theUniform, 4, &theColor.r);
        }

    theUniform = [theProgram uniformIndexForName:@"u_lightSource.specular"];
    if (theUniform != 0)
        {
        Color4f theColor = self.light.specularColor;
        glUniform4fv(theUniform, 4, &theColor.r);
        }

    theUniform = [theProgram uniformIndexForName:@"u_lightSource.position"];
    if (theUniform != 0)
        {
        Vector4 theVector = self.light.position;
        glUniform4fv(theUniform, 4, &theVector.x);
        }

    theUniform = [theProgram uniformIndexForName:@"u_lightSource.halfVector"];
    if (theUniform != 0)
        {
//    Vector3 theHalfVector = Vector3Add(Vector3Normalize(Vector3FromVector4(self.camera.position)), Vector3Normalize(Vector3FromVector4(self.light.position)));
        Vector3 theHalfVector = Vector3Normalize(Vector3Add(Vector3FromVector4(self.camera.position), Vector3FromVector4(self.light.position)));
        glUniform4f(theUniform, theHalfVector.x, theHalfVector.y, theHalfVector.z, 0);
        }


    // #### Light model
    if (theUniform != 0)
        {
        theUniform = [theProgram uniformIndexForName:@"u_lightModel.ambient"];
        glUniform4f(theUniform, 0.2, 0.2, 0.2, 1.0);
        }
    
    // #### Material
    CMaterial *theMaterial = self.defaultMaterial;
    
    theUniform = [theProgram uniformIndexForName:@"u_frontMaterial.ambient"];
    if (theUniform != 0)
        {
        Color4f theColor = theMaterial.ambientColor;
        glUniform4fv(theUniform, 4, &theColor.r);
        }

    if (theUniform != 0)
        {
        theUniform = [theProgram uniformIndexForName:@"u_frontMaterial.diffuse"];
        Color4f theColor = theMaterial.diffuseColor;
        glUniform4fv(theUniform, 4, &theColor.r);
        }

    if (theUniform != 0)
        {
        theUniform = [theProgram uniformIndexForName:@"u_frontMaterial.specular"];
        Color4f theColor = theMaterial.specularColor;
        glUniform4fv(theUniform, 4, &theColor.r);
        }

    if (theUniform != 0)
        {
        theUniform = [theProgram uniformIndexForName:@"u_frontMaterial.shininess"];
        glUniform1f(theUniform, theMaterial.shininess);    
        }

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
