//
//  CImageRenderer.m
//  SketchTest
//
//  Created by Jonathan Wight on 02/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CImageRenderer.h"

#import "CFrameBuffer.h"
#import "CRenderBuffer.h"
#import "CTexture.h"
#import "CImageTextureLoader.h"

@implementation CImageRenderer

@synthesize size;
@synthesize frameBuffer;
@synthesize depthBuffer;
@synthesize texture;

- (id)initWithSize:(SIntSize)inSize;
	{
	if ((self = [super init]) != NULL)
		{
        size = inSize;
        
        frameBuffer = [[CFrameBuffer alloc] init];

        depthBuffer = [[CRenderBuffer alloc] init];
        [depthBuffer storage:GL_DEPTH_COMPONENT16 size:inSize];
        [frameBuffer attachRenderBuffer:depthBuffer attachment:GL_DEPTH_ATTACHMENT];

        self.texture = [[CImageTextureLoader textureLoader] textureWithImageNamed:@"Brick" error:NULL];
        [frameBuffer attachTexture:texture attachment:GL_COLOR_ATTACHMENT0];
		}
	return(self);
	}

- (void)render
    {
    [self renderIntoFrameBuffer:self.frameBuffer transform:Matrix4Identity];
    }

@end
