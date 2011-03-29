//
//  CVertexArrayBuffer.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/24/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CVertexArrayBuffer.h"

#import "OpenGLIncludes.h"

@implementation CVertexArrayBuffer

@synthesize name;
@synthesize populated;

- (void)dealloc
    {
    if (name != 0)
        {
        #if TARGET_OS_IPHONE
        AssertOpenGLNoError_();
        glDeleteVertexArraysOES(1, &name);
        AssertOpenGLNoError_();
        #endif /* TARGET_OS_IPHONE */
        name = 0;
        }
    [super dealloc];
    }

- (GLuint)name
    {
    if (name == 0)
        {
        #if TARGET_OS_IPHONE
        AssertOpenGLNoError_();
        glGenVertexArraysOES(1, &name);
        AssertOpenGLNoError_();
        #endif /* TARGET_OS_IPHONE */
        }
    return(name);
    }

- (void)bind
    {
    #if TARGET_OS_IPHONE
    AssertOpenGLNoError_();
    glBindVertexArrayOES(self.name);
    AssertOpenGLNoError_();
    #endif /* TARGET_OS_IPHONE */
    }


- (void)unbind
    {
    #if TARGET_OS_IPHONE
    AssertOpenGLNoError_();
    glBindVertexArrayOES(0);
    AssertOpenGLNoError_();
    #endif /* TARGET_OS_IPHONE */
    }

@end
