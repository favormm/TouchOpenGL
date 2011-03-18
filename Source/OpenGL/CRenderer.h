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
    

- (void)prerender;
- (void)render:(Matrix4)inTransform;
- (void)postrender;

- (void)renderIntoFrameBuffer:(CFrameBuffer *)inFramebuffer transform:(Matrix4)inTransform;

@end

