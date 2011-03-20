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
#import "CLibrary.h"
#import "CProgram.h"
#import "UIColor_OpenGLExtensions.h"
#import "CMeshLoader.h"
#import "CMesh.h"
#import "CTexture.h"
#import "CImageTextureLoader.h"
#import "CMaterial.h"
#import "CRenderer_Extensions.h"

struct directional_light {
	Vector3 direction;
	Vector3 halfplane;
	Color4f ambient_color;
	Color4f diffuse_color;
	Color4f specular_color;
};

struct material_properties {
	Color4f ambient_color;
	Color4f diffuse_color;
	Color4f specular_color;
	GLfloat specular_exponent;
};

@interface COBJRenderer ()
@property (readwrite, nonatomic, retain) NSArray *meshes;
@property (readwrite, nonatomic, retain) CProgram *flatProgram;
@property (readwrite, nonatomic, retain) CProgram *textureProgram;
@property (readwrite, nonatomic, retain) CProgram *lightingProgram;
@property (readwrite, nonatomic, retain) CTexture *defaultTexture;
@end

@implementation COBJRenderer

@synthesize meshes;
@synthesize flatProgram;
@synthesize textureProgram;
@synthesize lightingProgram;
@synthesize defaultTexture;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        CMeshLoader *theLoader = [[[CMeshLoader alloc] init] autorelease];
        self.meshes = [theLoader loadMeshesFromFile:@"Skull"];
                
        
        self.flatProgram = [[[CProgram alloc] initWithName:@"Flat2" attributeNames:[NSArray arrayWithObjects:@"a_position", @"a_normal", NULL] uniformNames:[NSArray arrayWithObjects:@"u_mvpMatrix", @"u_diffuse_color", @"u_color", NULL]] autorelease];

        self.textureProgram = [[[CProgram alloc] initWithName:@"SimpleTexture" attributeNames:[NSArray arrayWithObjects:@"a_position", @"a_texCoord", NULL] uniformNames:[NSArray arrayWithObjects:@"u_mvpMatrix", NULL]] autorelease];

        self.lightingProgram = [[[CProgram alloc] initWithName:@"Lighting" attributeNames:[NSArray arrayWithObjects:@"a_position", @"a_normal", NULL] uniformNames:[NSArray arrayWithObjects:@"u_mvpMatrix", @"u_modelViewMatrix" /*, @"u_material", @"u_light"*/, NULL]] autorelease];
		}
	return(self);
	}

- (void)render:(Matrix4)inTransform
    {
    AssertOpenGLNoError_();


    const Matrix4 theTransform = Matrix4Scale(inTransform, 0.05, 0.05, 0.05);

    [self drawAxes:theTransform];

//    glFrontFace(GL_CCW);
//    glCullFace(GL_BACK);
//    glEnable(GL_CULL_FACE);


    for (CMesh *theMesh in self.meshes)
        {
        Vector3 theCenter = theMesh.center;
        Matrix4 theMeshTransform = Matrix4Concat(Matrix4MakeTranslation(-theCenter.x, -theCenter.y * 1.5, -theCenter.z), theTransform);


        CProgram *theProgram = self.flatProgram;
        
        if (theMesh.material.texture != NULL)
            {
            theProgram = self.textureProgram;
            }

        // Use shader program
        glUseProgram(theProgram.name);
        
        // Update position attribute
        GLuint thePositionsAttributeIndex = [theProgram attributeIndexForName:@"a_position"];        
        [theMesh.positions use:thePositionsAttributeIndex];
        glEnableVertexAttribArray(thePositionsAttributeIndex);

        GLuint theNormalsAttributeIndex = [theProgram attributeIndexForName:@"a_normal"];        
        [theMesh.normals use:theNormalsAttributeIndex];
        glEnableVertexAttribArray(theNormalsAttributeIndex);

        // Update transform uniform
        GLuint theTransformUniformIndex = [theProgram uniformIndexForName:@"u_mvpMatrix"];
        glUniformMatrix4fv(theTransformUniformIndex, 1, NO, &theMeshTransform.m00);

        if (theProgram == self.textureProgram)
            {
            CTexture *theTexture = theMesh.material.texture;
            
            glBindTexture(GL_TEXTURE_2D, theTexture.name);

            GLuint theTextureAttributeIndex = [theProgram attributeIndexForName:@"a_texCoord"];        
            [theMesh.texCoords use:theTextureAttributeIndex];
            glEnableVertexAttribArray(theTextureAttributeIndex);
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
            
            GLfloat theMat3[] = { 1, 0, 0, 0, 1, 0, 0, 0, 1 };
            
            GLuint theModelMatrixUniformIndex = [theProgram uniformIndexForName:@"u_modelViewMatrix"];
            glUniformMatrix3fv(theModelMatrixUniformIndex, 1, NO, theMat3);

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

        glDrawArrays(GL_TRIANGLES, 0, theMesh.positions.rowCount);
        }
    }


@end
