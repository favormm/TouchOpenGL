//
//  EAGLView.h
//  Dwarfs
//
//  Created by Jonathan Wight on 09/05/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "CRenderer.h"
#import "OpenGLTypes.h"

@class EAGLContext;
@class CAEAGLLayer;
@class CFrameBuffer;
@class CRenderBuffer;

@interface CRendererView : UIView {    
    NSInteger animationFrameInterval;
    CRenderer *renderer;
    BOOL animating;
    CADisplayLink *displayLink;
    EAGLContext *context;

    // The pixel dimensions of the CAEAGLLayer
    
    GLfloat aspectRatio;

    // The OpenGL ES names for the framebuffer and renderbuffer used to render to this view
//    GLuint viewFramebuffer, viewRenderbuffer, depthRenderbuffer;

}

@property (readwrite, nonatomic, assign) SIntSize backingSize;
@property (readwrite, nonatomic, assign) GLfloat aspectRatio;
@property (readwrite, nonatomic, retain) EAGLContext *context;
@property (readwrite, nonatomic, assign) NSInteger animationFrameInterval;
@property (readwrite, nonatomic, retain) CRenderer *renderer;
@property (readonly, nonatomic, assign) BOOL animating;

@property (readwrite, nonatomic, retain) CFrameBuffer *frameBuffer;
@property (readwrite, nonatomic, retain) CRenderBuffer *colorRenderBuffer;
@property (readwrite, nonatomic, retain) CRenderBuffer *depthRenderBuffer;


- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView:(id)sender;

@end
