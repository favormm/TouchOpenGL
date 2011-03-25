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
- (void)tick:(id)inSender;
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
@synthesize transform;

+ (Class)layerClass
    {
    return [CAEAGLLayer class];
    }

- (id)initWithFrame:(CGRect)inFrame;
    {    
    if ((self = [super initWithFrame:inFrame]))
        {
        animationFrameInterval = 1.0;
        transform = Matrix4Identity;
        }

    return self;
    }
    
- (id)initWithCoder:(NSCoder *)inDecoder
    {    
    if ((self = [super initWithCoder:inDecoder]) != NULL)
        {
        animationFrameInterval = 1.0;
        transform = Matrix4Identity;
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

- (void)layoutSubviews
    {
    [super layoutSubviews];
    //
    [self render];
    }

- (void)setup
    {
    // Get the layer
    self.EAGLLayer.opaque = TRUE;
    self.EAGLLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking,
        kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
        nil];

    if (context == NULL)
        {
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

        if (!context || ![EAGLContext setCurrentContext:context])
            {
            NSLog(@"ERROR");
            return;
            }
        
        AssertOpenGLNoError_();
        }
        
    }

#pragma mark -

- (void)setRenderer:(CRenderer *)inRenderer;
    {
    if (renderer != inRenderer)
        {
        [renderer release];
        renderer = [inRenderer retain];
        //
        if (renderer != NULL)
            {
//            [self setup];
            [self startAnimation];
            }


        }
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

        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        [displayLink setFrameInterval:self.animationFrameInterval];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        }
    }

- (void)stopAnimation
    {
    if (self.animating)
        {
        self.animating = FALSE;

        [displayLink invalidate];
        displayLink = nil;
        }
    }

- (void)tick:(id)inSender
    {
    #pragma unused (inSender)
    
    if (self.animating)
        {
        [self render];
        }
    }

- (void)render
    {
    NSAssert(self.renderer != NULL, @"No renderer");

    const CGSize theSize = self.bounds.size;

    if (self.context == NULL)
        {
        [self setup];
        [EAGLContext setCurrentContext:self.context];
        [self setupFramebuffers];
        
        [self.renderer setup];


        glViewport(0, 0, theSize.width, theSize.height);
        }
    
    theTransform = Matrix4Concat(theTransform, self.transform);

    [self.renderer renderIntoFrameBuffer:self.frameBuffer transform:theTransform];

    [self.colorRenderBuffer bind];
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
    
    // Discard frame buffers for extra performance: see http://www.khronos.org/registry/gles/extensions/EXT/EXT_discard_framebuffer.txt
    GLenum theAttachments[] = { GL_COLOR_ATTACHMENT0, GL_DEPTH_ATTACHMENT };
    glDiscardFramebufferEXT(GL_READ_FRAMEBUFFER_APPLE, 2, theAttachments);
    
    AssertOpenGLNoError_();
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
