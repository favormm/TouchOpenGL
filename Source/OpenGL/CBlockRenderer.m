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
    [super prerender];
    if (self.prerenderBlock)
        {
        self.prerenderBlock();
        }
    }

- (void)render:(Matrix4)inTransform
    {
    [super render:inTransform];
    if (self.renderBlock)
        {
        self.renderBlock(inTransform);
        }
    }

- (void)postrender
    {
    [super postrender];
    if (self.postrenderBlock)
        {
        self.postrenderBlock();
        }
    }

@end
