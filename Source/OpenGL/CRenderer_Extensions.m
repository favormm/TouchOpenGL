//
//  CRenderer_Extensions.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CRenderer_Extensions.h"

#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#import "CProgram.h"
#import "Color_OpenGLExtensions.h"
#import "COpenGLAssetLibrary.h"

@implementation CRenderer (CRenderer_Extensions)

- (COpenGLAssetLibrary *)library
    {
    #if TARGET_OS_IPHONE
    return([EAGLContext currentContext].library);
    #else
    
    static char kKey[] = "[CRenderer library]";
    
    COpenGLAssetLibrary *theLibrary = objc_getAssociatedObject(self, &kKey);
    if (theLibrary == NULL)
        {
        theLibrary = [[[COpenGLAssetLibrary  alloc] init] autorelease];
        objc_setAssociatedObject(self, &kKey, theLibrary, OBJC_ASSOCIATION_RETAIN);
        }
    return(theLibrary);
    #endif
    }

- (void)drawAxes:(Matrix4)inModelTransform
    {
    AssertOpenGLNoError_();

    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

    CProgram *theProgram = [self.library programForName:@"Flat" attributeNames:[NSArray arrayWithObjects:@"a_position", @"a_color", NULL] uniformNames:[NSArray arrayWithObjects:@"u_modelViewMatrix", @"u_projectionMatrix", NULL] error:NULL];

    const GLfloat kLength = 10000.0;

    Vector3 theVertices[] = {
        { .x = +kLength, .y = 0, .z = 0 },
        { .x = -kLength, .y = 0, .z = 0 },
        { .x = 0.0, .y = kLength, .z = 0 },
        { .x = 0.0, .y = -kLength, .z = 0 },
        { .x = 0.0, .y = 0, .z = kLength },
        { .x = 0.0, .y = 0, .z = -kLength },
        };

    Color4ub theColors[] = { 
        { 0xFF, 0, 0, 0xFF, },
        { 0xFF, 0, 0, 0xFF, },
        { 0, 0xFF, 0, 0xFF, },
        { 0, 0xFF, 0, 0xFF, },
        { 0, 0, 0xFF, 0xFF, },
        { 0, 0, 0xFF, 0xFF, },
        };

    // Use shader program
    [theProgram use];
    
    // Update position attribute
    GLuint theVertexAttributeIndex = [theProgram attributeIndexForName:@"a_position"];        
    glVertexAttribPointer(theVertexAttributeIndex, 3, GL_FLOAT, GL_FALSE, 0, theVertices);
    glEnableVertexAttribArray(theVertexAttributeIndex);

    AssertOpenGLNoError_();

    // Update color attribute
    GLuint theColorsAttributeIndex = [theProgram attributeIndexForName:@"a_color"];        
    glEnableVertexAttribArray(theColorsAttributeIndex);
    glVertexAttribPointer(theColorsAttributeIndex, 4, GL_UNSIGNED_BYTE, GL_TRUE, 0, theColors);

    AssertOpenGLNoError_();

    // Update transform uniform
    GLuint theModelViewMatrixUniform = [theProgram uniformIndexForName:@"u_modelViewMatrix"];
    glUniformMatrix4fv(theModelViewMatrixUniform, 1, NO, &inModelTransform.m[0][0]);

    GLuint theProjectionMatrixUniform = [theProgram uniformIndexForName:@"u_projectionMatrix"];
    Matrix4 theProjectionMatrix = self.projectionTransform;
    glUniformMatrix4fv(theProjectionMatrixUniform, 1, NO, &theProjectionMatrix.m[0][0]);


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

    glLineWidth(1);

    glDrawArrays(GL_LINES, 0, 6);

    AssertOpenGLNoError_();
    }

- (void)drawBoundingBox:(Matrix4)inModelTransform v1:(Vector3)v1 v2:(Vector3)v2;
    {
    AssertOpenGLNoError_();

//    inModelTransform = Matrix4Identity;

    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

    CProgram *theProgram = [self.library programForName:@"Flat" attributeNames:[NSArray arrayWithObjects:@"a_position", @"a_color", NULL] uniformNames:[NSArray arrayWithObjects:@"u_modelViewMatrix", @"u_projectionMatrix", NULL] error:NULL];

    // TODO should just have a static unit cube and then scale it with a matrix...
    Vector3 theVertices[] = {
        { .x = v1.x, .y = v1.y, .z = v1.z }, { .x = v2.x, .y = v1.y, .z = v1.z },
        { .x = v1.x, .y = v2.y, .z = v1.z }, { .x = v2.x, .y = v2.y, .z = v1.z },
        { .x = v1.x, .y = v1.y, .z = v1.z }, { .x = v1.x, .y = v2.y, .z = v1.z },
        { .x = v2.x, .y = v1.y, .z = v1.z }, { .x = v2.x, .y = v2.y, .z = v1.z },

        { .x = v1.x, .y = v1.y, .z = v2.z }, { .x = v2.x, .y = v1.y, .z = v2.z },
        { .x = v1.x, .y = v2.y, .z = v2.z }, { .x = v2.x, .y = v2.y, .z = v2.z },
        { .x = v1.x, .y = v1.y, .z = v2.z }, { .x = v1.x, .y = v2.y, .z = v2.z },
        { .x = v2.x, .y = v1.y, .z = v2.z }, { .x = v2.x, .y = v2.y, .z = v2.z },

        { .x = v1.x, .y = v1.y, .z = v1.z }, { .x = v1.x, .y = v1.y, .z = v2.z },
        { .x = v2.x, .y = v1.y, .z = v1.z }, { .x = v2.x, .y = v1.y, .z = v2.z },

        { .x = v1.x, .y = v2.y, .z = v1.z }, { .x = v1.x, .y = v2.y, .z = v2.z },
        { .x = v2.x, .y = v2.y, .z = v1.z }, { .x = v2.x, .y = v2.y, .z = v2.z },

        };

    // TODO - can't get glVertexAttrib4f to work.
    Color4ub theColors[] = { 
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        { 0xFF, 0xFF, 0xFF, 0xFF, },
        };

    // Use shader program
    [theProgram use];
    
    // Update position attribute
    GLuint theVertexAttributeIndex = [theProgram attributeIndexForName:@"a_position"];        
    glVertexAttribPointer(theVertexAttributeIndex, 3, GL_FLOAT, GL_FALSE, 0, theVertices);
    glEnableVertexAttribArray(theVertexAttributeIndex);

    AssertOpenGLNoError_();

    // Update color attribute
    GLuint theColorsAttributeIndex = [theProgram attributeIndexForName:@"a_color"];        
    glEnableVertexAttribArray(theColorsAttributeIndex);
    glVertexAttribPointer(theColorsAttributeIndex, 4, GL_UNSIGNED_BYTE, GL_TRUE, 0, theColors);
//    glVertexAttrib4f(theColorsAttributeIndex, 1.0, 1.0, 1.0, 1.0);

    AssertOpenGLNoError_();


    // Update transform uniform
    GLuint theModelViewMatrixUniform = [theProgram uniformIndexForName:@"u_modelViewMatrix"];
    glUniformMatrix4fv(theModelViewMatrixUniform, 1, NO, &inModelTransform.m[0][0]);

    GLuint theProjectionMatrixUniform = [theProgram uniformIndexForName:@"u_projectionMatrix"];
    Matrix4 theProjectionMatrix = self.projectionTransform;
    glUniformMatrix4fv(theProjectionMatrixUniform, 1, NO, &theProjectionMatrix.m[0][0]);


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

    glLineWidth(1);

    glDrawArrays(GL_LINES, 0, sizeof(theVertices) / sizeof(theVertices[0]));

    AssertOpenGLNoError_();
    }


@end
