//
//  EAGLView.m
//  Dwarfs
//
//  Created by Jonathan Wight on 09/05/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CRendererView.h"

#import "CRenderer.h"
#import "CFrameBuffer.h"
#import "CRenderBuffer.h"

@interface CRendererView ()
@property (readonly, nonatomic, assign) CADisplayLink *displayLink;

@property (readwrite, nonatomic, assign) BOOL animating;
@property (readonly, nonatomic, retain) CAEAGLLayer *EAGLLayer;

- (void)setup;
- (void)setupFramebuffers;
@end

#pragma mark -

@implementation CRendererView

@synthesize displayLink;
@synthesize backingSize;
@synthesize context;
@synthesize animationFrameInterval;
@synthesize renderer;
@synthesize animating;
@synthesize frameBuffer;
@synthesize colorRenderBuffer;
@synthesize depthRenderBuffer;

+ (Class)layerClass
    {
    return [CAEAGLLayer class];
    }

- (id)initWithCoder:(NSCoder*)coder
    {    
    if ((self = [super initWithCoder:coder]))
        {
        [self setup];
        }

    return self;
    }

- (id)initWithFrame:(CGRect)inFrame;
    {    
    if ((self = [super initWithFrame:inFrame]))
        {
        [self setup];
        }

    return self;
    }
    
- (void)dealloc
    {
    if ([EAGLContext currentContext] == context)
        {
        [EAGLContext setCurrentContext:nil];
        }
    
    [renderer release];
    renderer = NULL;

    [frameBuffer release];
    frameBuffer = NULL;
    
    [colorRenderBuffer release];
    colorRenderBuffer = NULL;
    
    [depthRenderBuffer release];
    depthRenderBuffer = NULL;
    
    [context release];
    context = NULL;

    [super dealloc];
    }

#pragma mark -

- (void)setup
    {
    NSLog(@"RENDER VIEW SETUP");
    
    // Get the layer
    self.EAGLLayer.opaque = TRUE;
    self.EAGLLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking,
        kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
        nil];

    renderer = [[CRenderer alloc] init];

    animating = FALSE;
    animationFrameInterval = 2;
    displayLink = NULL;

    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!context || ![EAGLContext setCurrentContext:context])
        {
        NSLog(@"ERROR");
        return;
        }

    GLenum theError = glGetError();
    if (theError != GL_NO_ERROR)
        {
        NSLog(@"Framebuffer Error?: %x", theError);
        }
        
    [self startAnimation];
    }

#pragma mark -

- (void)layoutSubviews
    {
	[EAGLContext setCurrentContext:context];
	[self setupFramebuffers];

    [self drawView:NULL];
    }

- (CAEAGLLayer *)EAGLLayer
    {
    return((CAEAGLLayer *)self.layer);
    }

- (void)setAnimationFrameInterval:(NSInteger)frameInterval
    {
    // Frame interval defines how many display frames must pass between each time the display link fires. The display link will only fire 30 times a second when the frame internal is two on a display that refreshes 60 times a second. The default frame interval setting of one will fire 60 times a second when the display refreshes at 60 times a second. A frame interval setting of less than one results in undefined behavior.
    if (frameInterval >= 1)
        {
        animationFrameInterval = frameInterval;
        if (self.animating)
            {
            [self stopAnimation];
            [self startAnimation];
            }
        }
    }

- (void)startAnimation
    {
    if (!self.animating)
        {
        self.animating = TRUE;

        NSLog(@"START ANIMATION");

        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView:)];
        [displayLink setFrameInterval:self.animationFrameInterval];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        }
    }

- (void)stopAnimation
    {
    if (self.animating)
        {
        self.animating = FALSE;

        NSLog(@"STOP ANIMATION");
        
        [displayLink invalidate];
        displayLink = nil;
        }
    }

- (void)drawView:(id)sender
    {
    if (self.animating)
        {
        // This application only creates a single context which is already set current at this point. This call is redundant, but needed if dealing with multiple contexts.
        [EAGLContext setCurrentContext:self.context];

        glViewport(0, 0, self.backingSize.width, self.backingSize.height);

        [self.renderer renderIntoFrameBuffer:self.frameBuffer];

        [self.colorRenderBuffer bind];
        [self.context presentRenderbuffer:GL_RENDERBUFFER];
        }
    }
    
#pragma mark -

- (void)setupFramebuffers
    {
    // Create frame buffer
    self.frameBuffer = [[[CFrameBuffer alloc] init] autorelease];
    
    // Create a color render buffer - and configure it with current context & drawable
    self.colorRenderBuffer = [[[CRenderBuffer alloc] init] autorelease];
    [self.colorRenderBuffer storageFromContext:self.context drawable:self.EAGLLayer];

    // Attach color buffer to frame buffer
    [self.frameBuffer attachRenderBuffer:self.colorRenderBuffer attachment:GL_COLOR_ATTACHMENT0];
    
    // Get the size of the color buffer (we'll be using this a lot)
    self.backingSize = self.colorRenderBuffer.size;
  
    // Create a depth buffer - and configure it to the size of the color buffer.
    self.depthRenderBuffer = [[[CRenderBuffer alloc] init] autorelease];
    [self.depthRenderBuffer storage:GL_DEPTH_COMPONENT16 size:self.backingSize];

    // Attach depth buffer to the frame buffer
    [self.frameBuffer attachRenderBuffer:self.depthRenderBuffer attachment:GL_DEPTH_ATTACHMENT];

    // Make sure the frame buffer has a complete set of render buffers.
	if (self.frameBuffer.complete == NO)
        {
		NSLog(@"createFramebuffer failed %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        }
    }


@end
