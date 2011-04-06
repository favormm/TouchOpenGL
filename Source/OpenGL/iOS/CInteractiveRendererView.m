//
//  CInteractiveRendererView.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/09/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CInteractiveRendererView.h"

#import <CoreMotion/CoreMotion.h>

#import "OpenGLTypes.h"
#import "CArcBall.h"
#import "Quaternion.h"
#import "COBJRenderer.h"

@interface CInteractiveRendererView ()
@property (readwrite, nonatomic, retain) CArcBall *arcBall;
@property (readwrite, nonatomic, assign) CGPoint arcBallCenter;
@property (readwrite, nonatomic, retain) CMMotionManager *motionManager;

- (void)pinch:(UIPinchGestureRecognizer *)inGestureRecognizer;
- (void)pan:(UIPanGestureRecognizer *)inGestureRecognizer;
@end

@implementation CInteractiveRendererView

@synthesize motionRotation;
@synthesize gestureRotation;
@synthesize savedRotation;
@synthesize scale;
@synthesize arcBall;
@synthesize arcBallCenter;
@synthesize motionManager;

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
        
        motionManager = [[CMMotionManager alloc] init];
        [motionManager startDeviceMotionUpdates];

        savedRotation = QuaternionIdentity;
        }

    return self;
    }
    
- (id)initWithCoder:(NSCoder *)inDecoder
    {    
    if ((self = [super initWithCoder:inDecoder]) != NULL)
        {

        arcBall = [[CArcBall alloc] init];
        
        scale = 1.0;
        
        UIPinchGestureRecognizer *thePinchGestureRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)] autorelease];
        [self addGestureRecognizer:thePinchGestureRecognizer];

        UIPanGestureRecognizer *thePanGestureRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)] autorelease];
        [self addGestureRecognizer:thePanGestureRecognizer];
        
        motionManager = [[CMMotionManager alloc] init];
        [motionManager startDeviceMotionUpdates];

        savedRotation = QuaternionIdentity;
        }

    return self;
    }

- (void)dealloc
    {
    [arcBall release];
    arcBall = NULL;
    
    [motionManager release];
    motionManager = NULL;
    //
    [super dealloc];
    }

- (void)render
    {
    CMDeviceMotion *theDeviceMotion = self.motionManager.deviceMotion;		

    CMQuaternion theCMRotation = theDeviceMotion.attitude.quaternion;
    
    self.motionRotation = (Quaternion){ theCMRotation.x, theCMRotation.y, theCMRotation.z, theCMRotation.w };

    Matrix4 theTransform = Matrix4MakeScale(self.scale, self.scale, self.scale);

    theTransform = Matrix4Concat(Matrix4FromQuaternion(self.motionRotation), theTransform);
    theTransform = Matrix4Concat(Matrix4FromQuaternion(self.gestureRotation), theTransform);
    
    ((COBJRenderer *)self.renderer).modelTransform = theTransform;
    
//    NSLog(@"%@", NSStringFromMatrix4(self.transform));
//    NSLog(@"%@", NSStringFromQuaternion(self.motionRotation));

    [super render];
    }



- (void)pinch:(UIPinchGestureRecognizer *)inGestureRecognizer
    {
//    NSLog(@"PINCH");
    
    self.scale += inGestureRecognizer.velocity / 10;
    self.scale = MAX(self.scale, 0.01);
    }

- (void)pan:(UIPanGestureRecognizer *)inGestureRecognizer
    {
//    NSLog(@"PAN: %d", inGestureRecognizer.state);
    
    CGSize theSize = self.bounds.size;
    CGPoint theLocation = [inGestureRecognizer locationInView:self];

    CGPoint thePoint = {
        .x = theLocation.x / theSize.width - 0.5f,
        .y = (theLocation.y / theSize.height - 0.5f) * -1.0,
        };

    if (inGestureRecognizer.state == UIGestureRecognizerStateBegan)
        {
        self.arcBallCenter = thePoint;
        [self.arcBall start:CGPointZero];
        
//        self,transgo
        }
    else if (inGestureRecognizer.state == UIGestureRecognizerStateChanged)
        {
        CGPoint center = self.arcBallCenter;
        CGPoint relativePoint = CGPointMake(thePoint.x - center.x, thePoint.y - center.y);
        [self.arcBall dragTo:relativePoint];
        
        self.gestureRotation = QuaternionMultiply(self.savedRotation, self.arcBall.rotation);
        }
    else if (inGestureRecognizer.state == UIGestureRecognizerStateEnded)
        {
        self.savedRotation = self.gestureRotation;
        }
    }

@end
