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
        light.position = camera.position;
        defaultMaterial = [[CMaterial alloc] init];
        modelTransform = Matrix4Identity;
                
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

- (void)setup
    {
    [super setup];
    //
    self.lightingProgram = [[[CProgram alloc] initWithName:@"Lighting" attributeNames:[NSArray arrayWithObjects:@"a_position", @"a_normal", NULL] uniformNames:[NSArray arrayWithObjects:@"u_modelViewMatrix", @"u_projectionMatrix", @"u_lightSource", @"u_lightModel", @"u_cameraPosition", @"s_texture0", NULL]] autorelease];

    // #### Set up lighting
	CProgram *theProgram = self.lightingProgram;
	glUseProgram(theProgram.name);

    GLuint theUniform = 0;

    // #### Light sources
    theUniform = [theProgram uniformIndexForName:@"u_lightSource.ambient"];
    if (theUniform != 0)
        {
        Color4f theColor = self.light.ambientColor;
        glUniform4fv(theUniform, 1, &theColor.r);
        }

    theUniform = [theProgram uniformIndexForName:@"u_lightSource.diffuse"];
    if (theUniform != 0)
        {
        Color4f theColor = self.light.diffuseColor;
        glUniform4fv(theUniform, 1, &theColor.r);
        }

    theUniform = [theProgram uniformIndexForName:@"u_lightSource.specular"];
    if (theUniform != 0)
        {
        Color4f theColor = self.light.specularColor;
        glUniform4fv(theUniform, 1, &theColor.r);
        }

    theUniform = [theProgram uniformIndexForName:@"u_lightSource.position"];
    if (theUniform != 0)
        {
        Vector4 theVector = self.light.position;
        glUniform4fv(theUniform, 1, &theVector.x);
        }

    // #### Light model
    if (theUniform != 0)
        {
        theUniform = [theProgram uniformIndexForName:@"u_lightModel.ambient"];
        glUniform4f(theUniform, 0.2, 0.2, 0.2, 1.0);
        }

    }

- (void)prerender
    {
    [super prerender];


    const float kSinMinus60Degrees = -0.866025404f;
    const float kCosMinus60Degrees = 0.5f;
    Vector3 cameraPosition = Vector3FromVector4(self.camera.position);
    GLfloat cameraDistance = Vector3Length(cameraPosition);
    GLfloat r = cameraDistance / kCosMinus60Degrees;
    if (r > 0.0f) {
        // Get an axis, A, that isn't parallel to the camera position, Cam.
        // Then Y = Cam x A is perpendicular to Cam.
        // Put the light in a position such that it makes a 60 degree
        // angle with Cam in the plane defined by (Cam, Y).
        Vector3 A;
        if (cameraPosition.y != 0.0f || cameraPosition.z != 0.0f) {
            // Camera position does not lie along the x-axis.  Put A on the x-axis.
            A.x = 1.0f;
            A.y = 0.0f;
            A.z = 0.0f;
        } else {
            // Camera position lies along the x-axis.  Put A on the (minus) z-axis.
            A.x = 0.0f;
            A.y = 0.0f;
            A.z = -1.0f;
        }
        Vector3 Y = Vector3Normalize(Vector3CrossProduct(cameraPosition, A));
        Vector3 X = Vector3Normalize(cameraPosition);
        Vector3 lightPosition;
        lightPosition.x = r * (X.x * kCosMinus60Degrees + Y.x * kSinMinus60Degrees);
        lightPosition.y = r * (X.y * kCosMinus60Degrees + Y.y * kSinMinus60Degrees);
        lightPosition.z = r * (X.z * kCosMinus60Degrees + Y.z * kSinMinus60Degrees);
        self.light.position = (Vector4) { lightPosition.x, lightPosition.y, lightPosition.z, 0.0f };
    } else {
        // Camera is at the origin, just put the light any old place.
        self.light.position = (Vector4) { 0.0f, 0.0f, -10.0f, 0.0f };
    }

    self.projectionTransform = Matrix4Identity;
    Vector4 theCameraVector = self.camera.position;
    
    Matrix4 theCameraTransform = Matrix4MakeTranslation(theCameraVector.x, theCameraVector.y, theCameraVector.z);
    Matrix4 theOrthoTransform = Matrix4Perspective(90, (GLfloat)self.size.width / (GLfloat)self.size.height, 0.1, 100);
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
    
    // #### Now render each geometry in mesh.
	for (CGeometry *theGeometry in self.mesh.geometries)
		{
        // #### Material
        CMaterial *theMaterial = theGeometry.material;
        if (theMaterial == NULL)
            {
            theMaterial = self.defaultMaterial;
            }
        
        theUniform = [theProgram uniformIndexForName:@"u_frontMaterial.ambient"];
        if (theUniform != 0)
            {
            Color4f theColor = theMaterial.ambientColor;
            glUniform4fv(theUniform, 1, &theColor.r);
            }

        theUniform = [theProgram uniformIndexForName:@"u_frontMaterial.diffuse"];
        if (theUniform != 0)
            {
            Color4f theColor = theMaterial.diffuseColor;
            glUniform4fv(theUniform, 1, &theColor.r);
            }

        theUniform = [theProgram uniformIndexForName:@"u_frontMaterial.specular"];
        if (theUniform != 0)
            {
            Color4f theColor = theMaterial.specularColor;
            glUniform4fv(theUniform, 1, &theColor.r);
            }

        theUniform = [theProgram uniformIndexForName:@"u_frontMaterial.shininess"];
        if (theUniform != 0)
            {
            glUniform1f(theUniform, theMaterial.shininess);    
            }

        theUniform = [theProgram uniformIndexForName:@"u_cameraPosition"];
        if (theUniform != 0)
            {
            Vector4 theCameraPosition = self.camera.position;
            
            glUniform4fv(theUniform, 1, &theCameraPosition.x);
            }

        if (theMaterial.texture != NULL)
            {
            theUniform = [theProgram uniformIndexForName:@"s_texture0"];
            if (theUniform != 0)
                {
                glActiveTexture(GL_TEXTURE0);
                //                    NSAssert(theMaterial.texture.name != 0, @"No texture to bind");
                glBindTexture(GL_TEXTURE_2D, theMaterial.texture.name);
                glUniform1i(theUniform, 0);
                }
            }

        // #### Vertices
        [theGeometry.vertexArrayBuffer bind];
        
        if (theGeometry.vertexArrayBuffer == NULL || theGeometry.vertexArrayBuffer.populated == NO)
            {
            // Update position attribute
            NSAssert(theGeometry.positions != NULL, @"No positions.");
            GLuint theAttributesIndex = [theProgram attributeIndexForName:@"a_position"];        
            [theGeometry.positions use:theAttributesIndex];
            glEnableVertexAttribArray(theAttributesIndex);

            // Update normal attribute
            NSAssert(theGeometry.normals != NULL, @"No normals.");
            theAttributesIndex = [theProgram attributeIndexForName:@"a_normal"];        
            [theGeometry.normals use:theAttributesIndex];
            glEnableVertexAttribArray(theAttributesIndex);

            // Update texcoord attribute
            if (theMaterial.texture != NULL)
                {
                NSAssert(theMaterial.texture.isValid == YES, @"Invalid texture");
                
                NSAssert(theGeometry.texCoords != NULL, @"No tex coords.");
                theAttributesIndex = [theProgram attributeIndexForName:@"a_texCoord"];        
                [theGeometry.texCoords use:theAttributesIndex];
                glEnableVertexAttribArray(theAttributesIndex);
                
                            
                AssertOpenGLNoError_();
                }
            
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
