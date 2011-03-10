//
//  CInteractiveRendererView.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/09/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CInteractiveRendererView.h"

#import "OpenGLTypes.h"
#import "CArcBall.h"

@interface CInteractiveRendererView ()
@property (readwrite, nonatomic, assign) CGFloat scale;
@property (readwrite, nonatomic, retain) CArcBall *arcBall;
@end

@implementation CInteractiveRendererView

@synthesize scale;
@synthesize arcBall;

- (id)initWithFrame:(CGRect)inFrame;
    {    
    if ((self = [super initWithFrame:inFrame]))
        {
        arcBall = [[CArcBall alloc] init];
        
        scale = 1.0;
        
        UIPinchGestureRecognizer *thePinchGestureRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)] autorelease];
        [self addGestureRecognizer:thePinchGestureRecognizer];

        UIPanGestureRecognizer *thePanGestureRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)] autorelease];
        [self addGestureRecognizer:thePanGestureRecognizer];
        
        }

    return self;
    }

- (void)pinch:(UIPinchGestureRecognizer *)inGestureRecognizer
    {
    self.scale += inGestureRecognizer.scale - 1.0;
    self.transform = Matrix4MakeScale(self.scale, self.scale, self.scale);
    }

- (void)pan:(UIPanGestureRecognizer *)inGestureRecognizer
    {
    NSLog(@"PAN: %d", inGestureRecognizer.state);
    
    if (inGestureRecognizer.state == 1)
        {
        [self.arcBall start:CGPointZero];
        
//        self,transgo
        }
    else if (inGestureRecognizer.state == 1)
        {
        [self.arcBall start:CGPointZero];
        }
        
    
    }

@end
