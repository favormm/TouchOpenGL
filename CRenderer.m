//
//  ES2Renderer.m
//  Racing Genes
//
//  Created by Jonathan Wight on 09/05/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CRenderer.h"

#import <QuartzCore/QuartzCore.h>

@interface CRenderer ()
@property (readwrite, nonatomic, assign) BOOL prepared;
@end

#pragma mark -

@implementation CRenderer

@synthesize prepareBlock;
@synthesize prerenderBlock;
@synthesize renderBlock;
@synthesize postrenderBlock;

@synthesize prepared;

- (id)init
    {
    if ((self = [super init]))
        {
        }

    return self;
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

#pragma mark -

- (void)prerender
    {
    if (self.prepared == NO && self.prepareBlock)
        {
        self.prepareBlock();

        self.prepared = YES;
        }
    
    if (self.prerenderBlock)
        {
        self.prerenderBlock();
        }

    }

- (void)render
    {
    if (self.renderBlock)
        {
        self.renderBlock();
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
