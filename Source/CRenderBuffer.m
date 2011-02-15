//
//  CRenderBuffer.m
//  SketchTest
//
//  Created by Jonathan Wight on 02/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CRenderBuffer.h"


@implementation CRenderBuffer

@synthesize name;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        glGenRenderbuffers(1, &name);

        AssertOpenGLNoError_();
		}
	return(self);
	}

- (void)dealloc
    {
    glDeleteRenderbuffers(1, &name);
    //
    [super dealloc];
    }

- (SIntSize)size
    {
    [self bind];
    
    SIntSize theSize;
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &theSize.width);
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &theSize.height);

    AssertOpenGLNoError_();

    return(theSize);
    }

- (void)bind
    {
    glBindRenderbuffer(GL_RENDERBUFFER, self.name);
    }

- (void)storage:(GLenum)inIntermalFormat size:(SIntSize)inSize;
    {
    [self bind];
    glRenderbufferStorage(GL_RENDERBUFFER, inIntermalFormat, inSize.width, inSize.height);

    AssertOpenGLNoError_();
    }
    
- (void)storageFromContext:(EAGLContext *)inContext drawable:(id <EAGLDrawable>)inDrawable
    {
    [self bind];
    
    [inContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:inDrawable];

    AssertOpenGLNoError_();
    }

@end
