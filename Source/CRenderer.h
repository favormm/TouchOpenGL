//
//  ES2Renderer.h
//  Racing Genes
//
//  Created by Jonathan Wight on 09/05/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OpenGLIncludes.h"

@class CFrameBuffer;

@interface CRenderer : NSObject {
    }

@property (readwrite, nonatomic, copy) void (^prepareBlock)(void);
@property (readwrite, nonatomic, copy) void (^prerenderBlock)(void);
@property (readwrite, nonatomic, copy) void (^renderBlock)(void);
@property (readwrite, nonatomic, copy) void (^postrenderBlock)(void);

- (void)prerender;
- (void)render;
- (void)postrender;

- (void)renderIntoFrameBuffer:(CFrameBuffer *)inFramebuffer;

@end

