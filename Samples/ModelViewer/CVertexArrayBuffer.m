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
        AssertOpenGLNoError_();
        glDeleteVertexArraysOES(1, &name);
        AssertOpenGLNoError_();
        name = 0;
        }
    [super dealloc];
    }

- (GLuint)name
    {
    if (name == 0)
        {
        AssertOpenGLNoError_();
        glGenVertexArraysOES(1, &name);
        AssertOpenGLNoError_();
        }
    return(name);
    }

- (void)bind
    {
    AssertOpenGLNoError_();
    glBindVertexArrayOES(self.name);
    AssertOpenGLNoError_();
    }


- (void)unbind
    {
    AssertOpenGLNoError_();
    glBindVertexArrayOES(0);
    AssertOpenGLNoError_();
    }

@end
