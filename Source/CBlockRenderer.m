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
