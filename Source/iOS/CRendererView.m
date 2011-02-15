//
//  EAGLView.m
//  Dwarfs
//
//  Created by Jonathan Wight on 09/05/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CRendererView.h"

#import "CRenderer.h"

@interface CRendererView ()
@property (readwrite, nonatomic, assign) BOOL animating;
@property (readonly, nonatomic, retain) CAEAGLLayer *EAGLLayer;

- (void)setup;
- (void)createFramebuffer;
- (void)destroyFramebuffer;
@end

#pragma mark -

@implementation CRendererView

@synthesize backingWidth;
@synthesize backingHeight;
@synthesize aspectRatio;
@synthesize context;
@synthesize animationFrameInterval;
@synthesize renderer;
@synthesize animating;

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
    NSLog(@"%@ dealloc", self);
    // Tear down GL
    [self destroyFramebuffer];

    // Tear down context
    if ([EAGLContext currentContext] == context)
        {
        [EAGLContext setCurrentContext:nil];
        }

    [context release];
    context = NULL;
    

    [renderer release];
    renderer = NULL;

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
    }

#pragma mark -

- (void)layoutSubviews
    {
	[EAGLContext setCurrentContext:context];
	[self destroyFramebuffer];
	[self createFramebuffer];

    self.aspectRatio = (GLfloat)backingWidth / (GLfloat)backingHeight;
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
        // This application only creates a single default framebuffer which is already bound at this point. This call is redundant, but needed if dealing with multiple framebuffers.
        glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
        glViewport(0, 0, backingWidth, backingHeight);

        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

        glEnable(GL_DEPTH_TEST);
        
        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        glClearDepthf(1.0f);
        glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);

        [self.renderer render];
        
        // This application only creates a single color renderbuffer which is already bound at this point. This call is redundant, but needed if dealing with multiple renderbuffers.
        glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
        [self.context presentRenderbuffer:GL_RENDERBUFFER];
        }
    }
    
#pragma mark -

- (void)createFramebuffer
{
	glGenFramebuffers(1, &viewFramebuffer);
	glGenRenderbuffers(1, &viewRenderbuffer);
    
	glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, viewRenderbuffer);
	[context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, viewRenderbuffer);
    
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
	glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
  
	glGenRenderbuffers(1, &depthRenderbuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer);
	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, backingWidth, backingHeight);
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);
    
	if(glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
		NSLog(@"createFramebuffer failed %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
	} else {
		NSLog(@"Created framebuffer with backing width, height = (%d, %d)", backingWidth, backingHeight);
	}
}


- (void)destroyFramebuffer
{
	glDeleteFramebuffers(1, &viewFramebuffer);
	viewFramebuffer = 0;
	glDeleteRenderbuffers(1, &viewRenderbuffer);
	viewRenderbuffer = 0;
	glDeleteRenderbuffers(1, &depthRenderbuffer);
	depthRenderbuffer = 0;
}

@end
