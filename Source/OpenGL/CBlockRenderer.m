//
//  CBlockRenderer.m
//  SketchTest
//
//  Created by Jonathan Wight on 02/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CBlockRenderer.h"


@implementation CBlockRenderer

@synthesize prerenderBlock;
@synthesize renderBlock;
@synthesize postrenderBlock;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        self.prerenderBlock = ^(void) {
            glEnable(GL_BLEND);
            glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

            glEnable(GL_DEPTH_TEST);

            glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
            glClearDepthf(1.0f);
            glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
            };
		}
	return(self);
	}

- (void)dealloc
    {
 	[prerenderBlock release];
	prerenderBlock = NULL;

    [renderBlock release];
    renderBlock = NULL;

    [postrenderBlock release];
    postrenderBlock = NULL;

    [super dealloc];
    }

- (void)prerender
    {
    if (self.prerenderBlock)
        {
        self.prerenderBlock();
        }
    }

- (void)render:(Matrix4)inTransform
    {
    if (self.renderBlock)
        {
        self.renderBlock(inTransform);
        }
    }

- (void)postrender
    {
    if (self.postrenderBlock)
        {
        self.postrenderBlock();
        }
    }

@end
