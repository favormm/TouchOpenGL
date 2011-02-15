//
//  CFrameBuffer.m
//  SketchTest
//
//  Created by Jonathan Wight on 02/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CFrameBuffer.h"

#import "CRenderBuffer.h"

#import "CTexture.h"

@implementation CFrameBuffer

@synthesize name;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        glGenFramebuffers(1, &name);

        AssertOpenGLNoError_();
		}
	return(self);
	}

- (void)dealloc
    {
    glDeleteFramebuffers(1, &name);
    //
    [super dealloc];
    }

- (BOOL)complete
    {
    [self bind];
    GLenum theStatus = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    return(theStatus == GL_FRAMEBUFFER_COMPLETE);
    }

- (void)bind
    {
    glBindFramebuffer(GL_FRAMEBUFFER, self.name);
    }

- (void)attachRenderBuffer:(CRenderBuffer *)inRenderBuffer attachment:(GLenum)inAttachment
    {
    [self bind];
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, inAttachment, GL_RENDERBUFFER, inRenderBuffer.name);
    AssertOpenGLNoError_();
    }
    
- (void)attachTexture:(CTexture *)inTexture attachment:(GLenum)inAttachment
    {
    [self bind];
    glFramebufferTexture2D(GL_FRAMEBUFFER, inAttachment, GL_TEXTURE_2D, inTexture.name, 0);
    AssertOpenGLNoError_();
    }

@end
