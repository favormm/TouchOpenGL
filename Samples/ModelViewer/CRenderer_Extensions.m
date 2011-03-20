//
//  CRenderer_Extensions.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CRenderer_Extensions.h"

#import "CProgram.h"
#import "UIColor_OpenGLExtensions.h"

@implementation CRenderer (CRenderer_Extensions)

- (void)drawAxes:(Matrix4)inTransform
    {
    AssertOpenGLNoError_();

//    inTransform = Matrix4Identity;

    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

    CProgram *theProgram = [[[CProgram alloc] initWithName:@"Flat" attributeNames:[NSArray arrayWithObjects:@"a_position", @"_color", NULL] uniformNames:[NSArray arrayWithObjects:@"u_mvpMatrix", NULL]] autorelease];

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

    
    // Update position attribute
    GLuint theVertexAttributeIndex = [theProgram attributeIndexForName:@"a_position"];        
    glVertexAttribPointer(theVertexAttributeIndex, 3, GL_FLOAT, GL_FALSE, 0, theVertices);
    glEnableVertexAttribArray(theVertexAttributeIndex);

    AssertOpenGLNoError_();

    // Update color attribute
    GLuint theColorsAttributeIndex = [theProgram attributeIndexForName:@"a_color"];        
    glEnableVertexAttribArray(theColorsAttributeIndex);
    glVertexAttribPointer(theColorsAttributeIndex, 4, GL_UNSIGNED_BYTE, GL_TRUE, 0, theColors);
//    glVertexAttrib4f(theColorsAttributeIndex, 1.0, 0.0, 0.0, 1.0);

    AssertOpenGLNoError_();

    glUseProgram(theProgram.name);


    // Update transform uniform
    GLuint theTransformUniformIndex = [theProgram uniformIndexForName:@"u_mvpMatrix"];
    glUniformMatrix4fv(theTransformUniformIndex, 1, NO, &inTransform.m00);

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

    AssertOpenGLNoError_();

    glLineWidth(1);

    glDrawArrays(GL_LINES, 0, 6);

    AssertOpenGLNoError_();
    }

@end
