//
//  CGeometryNode.m
//  Racing Genes
//
//  Created by Jonathan Wight on 09/23/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CSceneGeometry.h"

#import <QuartzCore/QuartzCore.h>

#import "OpenGLTypes.h"
#import "CVertexBuffer.h"
#import "CProgram.h"
#import "CShader.h"
#import "CTexture.h"
#import "CVertexBufferReference.h"
#import "CSceneGraphRenderer.h"
#import "CSceneStyle.h"

@implementation CSceneGeometry

@synthesize indicesBufferReference;
@synthesize coordinatesBufferReference;
@synthesize textureCoordinatesBufferReference;
@synthesize colorsBufferReference;
@synthesize vertexBuffers;

- (void)dealloc
    {
    [indicesBufferReference release];
    indicesBufferReference = NULL;

    [coordinatesBufferReference release];
    coordinatesBufferReference = NULL;

    [textureCoordinatesBufferReference release];
    textureCoordinatesBufferReference = NULL;

    [colorsBufferReference release];
    colorsBufferReference = NULL;

    [vertexBuffers release];
    vertexBuffers = NULL;
    //
    [super dealloc];
    }


- (void)render:(CSceneGraphRenderer *)inRenderer;
    {
    CSceneStyle *theStyle = [inRenderer mergedStyle];
    
    // Use shader program
    CProgram *theProgram = theStyle.program;
    
    glUseProgram(theProgram.name);

    AssertOpenGLNoError_();

    // Update uniform value
    GLuint theTransformUniformIndex = [theProgram uniformIndexForName:@"transform"];
    Matrix4 theTransform = self.transform;
    theTransform = Matrix4Concat(theTransform, inRenderer.transform);
    theTransform = Matrix4Scale(theTransform, 0.005, 0.005, 1.0);
    glUniformMatrix4fv(theTransformUniformIndex, 1, NO, &theTransform.m00);

    // Update attribute values
    if (self.coordinatesBufferReference)
        {
        const GLuint theVertexAttributeIndex = [theProgram attributeIndexForName:@"vertex"];
        glBindBuffer(GL_ARRAY_BUFFER, self.coordinatesBufferReference.vertexBuffer.name);
        glVertexAttribPointer(theVertexAttributeIndex, self.coordinatesBufferReference.size, self.coordinatesBufferReference.type, self.coordinatesBufferReference.normalized, self.coordinatesBufferReference.stride, NULL);
        glEnableVertexAttribArray(theVertexAttributeIndex);
        }
    else
        {
        const GLuint theVertexAttributeIndex = [theProgram attributeIndexForName:@"vertex"];
        glDisableVertexAttribArray(theVertexAttributeIndex);
        }

    if (self.colorsBufferReference)
        {
        const GLuint theColorAttributeIndex = [theProgram attributeIndexForName:@"color"];
        glBindBuffer(GL_ARRAY_BUFFER, self.colorsBufferReference.vertexBuffer.name);
        glVertexAttribPointer(theColorAttributeIndex, self.colorsBufferReference.size, self.colorsBufferReference.type, self.colorsBufferReference.normalized, self.colorsBufferReference.stride, NULL);
        glEnableVertexAttribArray(theColorAttributeIndex);
        }
    else
        {
        const GLuint theVertexAttributeIndex = [theProgram attributeIndexForName:@"color"];
        glDisableVertexAttribArray(theVertexAttributeIndex);
        }
    
    if (theStyle.texture && self.textureCoordinatesBufferReference)
        {
        const GLuint theTextureAttributeIndex = [theProgram attributeIndexForName:@"texture"];
        glBindBuffer(GL_ARRAY_BUFFER, self.textureCoordinatesBufferReference.vertexBuffer.name);
        glVertexAttribPointer(theTextureAttributeIndex, self.textureCoordinatesBufferReference.size, self.textureCoordinatesBufferReference.type, self.textureCoordinatesBufferReference.normalized, self.textureCoordinatesBufferReference.stride, NULL);
        glEnableVertexAttribArray(theTextureAttributeIndex);

        glBindTexture(GL_TEXTURE_2D, theStyle.texture.name);
        }
    else
        {
        const GLuint theVertexAttributeIndex = [theProgram attributeIndexForName:@"texture"];
        glDisableVertexAttribArray(theVertexAttributeIndex);
        }
        

        
    AssertOpenGLNoError_();


    [super render:inRenderer];
    


    }

@end
