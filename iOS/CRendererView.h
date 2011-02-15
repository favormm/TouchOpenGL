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

@class EAGLContext;
@class CAEAGLLayer;

@interface CRendererView : UIView {    
    NSInteger animationFrameInterval;
    CRenderer *renderer;
    BOOL animating;
    CADisplayLink *displayLink;
    EAGLContext *context;

    // The pixel dimensions of the CAEAGLLayer
    GLint backingWidth;
    GLint backingHeight;
    GLfloat aspectRatio;

    // The OpenGL ES names for the framebuffer and renderbuffer used to render to this view
    GLuint viewFramebuffer, viewRenderbuffer, depthRenderbuffer;
}

@property (readwrite, nonatomic, assign) GLint backingWidth;
@property (readwrite, nonatomic, assign) GLint backingHeight;
@property (readwrite, nonatomic, assign) GLfloat aspectRatio;
@property (readwrite, nonatomic, retain) EAGLContext *context;
@property (readwrite, nonatomic, assign) NSInteger animationFrameInterval;
@property (readwrite, nonatomic, retain) CRenderer *renderer;
@property (readonly, nonatomic, assign) BOOL animating;

- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView:(id)sender;

@end
