//
//  ES2Renderer.h
//  Racing Genes
//
//  Created by Jonathan Wight on 09/05/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OpenGLIncludes.h"
#import "OpenGLTypes.h"
#import "Matrix.h"

@class CFrameBuffer;

@interface CRenderer : NSObject {
    }

@property (readwrite, nonatomic, assign) Matrix4 projectionTransform;

- (void)setup;
- (void)clear;
- (void)prerender;
- (void)render;
- (void)postrender;

- (void)renderIntoFrameBuffer:(CFrameBuffer *)inFramebuffer;

@end

