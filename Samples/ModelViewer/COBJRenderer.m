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
#import "CNewMesh.h"
#import "CNewModelLoader.h"
#import "CGeometry.h"
#import "CVertexArrayBuffer.h"

@interface COBJRenderer ()
@property (readwrite, nonatomic, retain) CNewMesh *mesh;
@property (readwrite, nonatomic, retain) CProgram *flatProgram;
@property (readwrite, nonatomic, retain) CProgram *textureProgram;
@property (readwrite, nonatomic, retain) CProgram *lightingProgram;
@end

@implementation COBJRenderer

@synthesize mesh;
@synthesize flatProgram;
@synthesize textureProgram;
@synthesize lightingProgram;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        CNewModelLoader *theLoader = [[[CNewModelLoader alloc] init] autorelease];
		NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"Skull2" withExtension:@"model.plist"];
        self.mesh = [theLoader loadMeshWithURL:theURL error:NULL];
        
        self.flatProgram = [[[CProgram alloc] initWithName:@"Flat2" attributeNames:[NSArray arrayWithObjects:@"a_position", @"a_normal", NULL] uniformNames:[NSArray arrayWithObjects:@"u_modelViewMatrix", @"u_projectionMatrix", @"u_color", NULL]] autorelease];

        self.textureProgram = [[[CProgram alloc] initWithName:@"SimpleTexture" attributeNames:[NSArray arrayWithObjects:@"a_position", @"a_texCoord", NULL] uniformNames:[NSArray arrayWithObjects:@"u_modelViewMatrix",  @"u_projectionMatrix", NULL]] autorelease];

        self.lightingProgram = [[[CProgram alloc] initWithName:@"Lighting" attributeNames:[NSArray arrayWithObjects:@"a_position", @"a_normal", NULL] uniformNames:[NSArray arrayWithObjects:@"u_modelViewMatrix", @"u_projectionMatrix"/*, @"u_material", @"u_light"*/, NULL]] autorelease];
		}
	return(self);
	}

- (void)dealloc
    {
    [mesh release];
    mesh = NULL;
    
    [flatProgram release];
    flatProgram = NULL;
    
    [textureProgram release];
    textureProgram = NULL;
    
    [lightingProgram release];
    lightingProgram = NULL;
    
    //
    [super dealloc];
    }

- (void)render:(Matrix4)inTransform
    {
    AssertOpenGLNoError_();

	Vector3 P1 = self.mesh.p1;
	Vector3 P2 = self.mesh.p2;

	GLfloat theScale = 1.0 / Vector3Length((Vector3){ fabs(P1.x - P2.x), fabs(P1.y - P2.y), fabs(P1.z - P2.z) }); 

    Matrix4 theTransform = Matrix4Scale(inTransform, theScale, theScale, theScale);

    [self drawAxes:theTransform];
    
    glCullFace(GL_BACK);
    glEnable(GL_CULL_FACE);

	Vector3 theCenter = self.mesh.center;
	theTransform = Matrix4Concat(Matrix4MakeTranslation(-theCenter.x, -theCenter.y, -theCenter.z), theTransform);

    [self drawBoundingBox:theTransform v1:P1 v2:P2];


	CProgram *theProgram = self.lightingProgram;
	
//	if (theMesh.material.texture != NULL)
//		{
//		theProgram = self.textureProgram;
//		}

	// Use shader program
	glUseProgram(theProgram.name);

    // Update transform uniform
    GLuint theModelViewMatrixUniform = [theProgram uniformIndexForName:@"u_modelViewMatrix"];
    glUniformMatrix4fv(theModelViewMatrixUniform, 1, NO, &theTransform.m00);

    GLuint theProjectionMatrixUniform = [theProgram uniformIndexForName:@"u_projectionMatrix"];
    glUniformMatrix4fv(theProjectionMatrixUniform, 1, NO, &Matrix4Identity.m00);

    if (theProgram == self.textureProgram)
        {
//			CTexture *theTexture = theMesh.material.texture;
//			
//			glBindTexture(GL_TEXTURE_2D, theTexture.name);
//
//			GLuint theTextureAttributeIndex = [theProgram attributeIndexForName:@"a_texCoord"];        
//			[theMesh.texCoords use:theTextureAttributeIndex];
//			glEnableVertexAttribArray(theTextureAttributeIndex);
        }
    else if (theProgram == self.flatProgram)
        {
#if TARGET_OS_IPHONE
        Color4f theColor = [UIColor redColor].color4f;
#elif TARGET_OS_MAC
        Color4f theColor = [NSColor redColor].color4f;
#endif
        GLuint theColorUniformIndex = [theProgram uniformIndexForName:@"u_color"];
        glUniform4fv(theColorUniformIndex, 1, &theColor.r);
        }
    else if (theProgram == self.lightingProgram)
        {
        AssertOpenGLNoError_();
        
//            Color4f theColor = [UIColor redColor].color4f;
//            GLuint theColorUniformIndex = [theProgram uniformIndexForName:@"u_color"];
//            glUniform4fv(theColorUniformIndex, 1, &theColor.r);
        }


    // #### Now render each geometry in mesh.
	for (CGeometry *theGeometry in self.mesh.geometries)
		{
        [theGeometry.vertexArrayBuffer bind];
        
        if (theGeometry.vertexArrayBuffer.populated == NO)
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

        // TODO -- currently indexed drawing is broken.
        if (theGeometry.indices == NULL)
            {
            glDrawArrays(GL_TRIANGLES, 0, theGeometry.positions.rowCount);
            }
        else
            {
            glDrawElements(GL_TRIANGLES, theGeometry.indices.rowCount, GL_UNSIGNED_SHORT, 0);
            }
		}

    glBindVertexArrayOES(0);
    }


@end
