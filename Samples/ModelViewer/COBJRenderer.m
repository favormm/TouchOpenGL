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
#import "UIColor_OpenGLExtensions.h"
#import "CTexture.h"
#import "CImageTextureLoader.h"
#import "CMaterial.h"
#import "CRenderer_Extensions.h"
#import "CNewMesh.h"
#import "CNewModelLoader.h"
#import "CGeometry.h"

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


    Matrix4 theTransform = Matrix4Scale(inTransform, 0.05, 0.05, 0.05);

    [self drawAxes:theTransform];

//    glFrontFace(GL_CCW);
//    glCullFace(GL_BACK);
//    glEnable(GL_CULL_FACE);


	Vector3 theCenter = self.mesh.center;
	theTransform = Matrix4Concat(Matrix4MakeTranslation(theCenter.x, -20, theCenter.z), theTransform);


	CProgram *theProgram = self.lightingProgram;
	
//	if (theMesh.material.texture != NULL)
//		{
//		theProgram = self.textureProgram;
//		}

	// Use shader program
	glUseProgram(theProgram.name);

	for (CGeometry *theGeometry in self.mesh.geometries)
		{
		// Update position attribute
		NSAssert(theGeometry.positions != NULL, @"No positions.");
		GLuint thePositionsAttributeIndex = [theProgram attributeIndexForName:@"a_position"];        
		[theGeometry.positions use:thePositionsAttributeIndex];
		glEnableVertexAttribArray(thePositionsAttributeIndex);


		NSAssert(theGeometry.normals != NULL, @"No normals.");
		GLuint theNormalsAttributeIndex = [theProgram attributeIndexForName:@"a_normal"];        
		[theGeometry.normals use:theNormalsAttributeIndex];
		glEnableVertexAttribArray(theNormalsAttributeIndex);

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
			Color4f theColor = [UIColor redColor].color4f;
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


		// Validate program before drawing. This is a good check, but only really necessary in a debug build. DEBUG macro must be defined in your debug configurations if that's not already the case.
	#if defined(DEBUG)
		NSError *theError = NULL;
		if ([theProgram validate:&theError] == NO)
			{
			NSLog(@"Failed to validate program: %@", theError);
			return;
			}
	#endif

		AssertOpenGLNoError_();

		glDrawArrays(GL_TRIANGLES, 0, theGeometry.positions.rowCount);
		}
    }


@end
