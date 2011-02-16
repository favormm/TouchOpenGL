//
//  ES2Renderer.m
//  Racing Genes
//
//  Created by Jonathan Wight on 09/05/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CRenderer.h"

#import <QuartzCore/QuartzCore.h>

#import "CFrameBuffer.h"

@interface CRenderer ()
@end

#pragma mark -

@implementation CRenderer

- (id)init
    {
    if ((self = [super init]))
        {
        }

    return self;
    }

- (void)dealloc
    {
    //
    [super dealloc];
    }

#pragma mark -

- (void)prerender
    {
    }

- (void)render:(Matrix4)inTransform
    {
    }

- (void)postrender
    {
    }

- (void)renderIntoFrameBuffer:(CFrameBuffer *)inFramebuffer transform:(Matrix4)inTransform
    {
    [inFramebuffer bind];
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    glEnable(GL_DEPTH_TEST);

    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClearDepthf(1.0f);
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);

    [self prerender];
    [self render:inTransform];
    [self postrender];
    }

@end
