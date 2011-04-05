//
//  PopTipDocument.m
//  PopTipEditor
//
//  Created by Aaron Golden on 3/21/11.
//  Copyright 2011 Inkling. All rights reserved.
//

#import "CModelDocument.h"

#import "CRendererView.h"
#import "CRendererOpenGLLayer.h"
#import "COBJRenderer.h"
#import "Matrix.h"
#import "Quaternion.h"
#import "CLight.h"
#import "Color_OpenGLExtensions.h"
#import "CCamera.h"
#import "CMeshLoader.h"
#import "CArcBall.h"

@interface ArcBallView : NSView
@property (nonatomic, retain) CArcBall *arcBall;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) Quaternion startQuaternion;
@property (nonatomic, assign) CModelDocument *document;
@end

@implementation ArcBallView

@synthesize arcBall = _arcBall;
@synthesize startPoint = _startPoint;
@synthesize startQuaternion = _startQuaternion;
@synthesize document = _document;

- (id)initWithFrame:(NSRect)frameRect
{
    if ((self = [super initWithFrame:frameRect])) {
        _arcBall = [[CArcBall alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_arcBall release];
    [super dealloc];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    _startPoint = [self convertPointFromBase:[theEvent locationInWindow]];
    _startQuaternion = QuaternionSetEuler(_document.yaw * M_PI / 180.0f, _document.pitch * M_PI / 180.0f, _document.roll * M_PI / 180.0f);
    [_arcBall start:CGPointZero];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    CGRect selfBounds = [self bounds];
    CGPoint newPoint = [self convertPointFromBase:[theEvent locationInWindow]];
    CGFloat dx = (_startPoint.x - newPoint.x) / selfBounds.size.width;
    CGFloat dy = (_startPoint.y - newPoint.y) / selfBounds.size.height;
    [_arcBall dragTo:CGPointMake(dx, dy)];

    GLfloat yaw, pitch, roll;
    Quaternion q = QuaternionMultiply(_startQuaternion, _arcBall.rotation);
    QuaternionGetEuler(q, &yaw, &pitch, &roll);
    [_document setYaw:yaw * 180.0f / M_PI];
    [_document setPitch:pitch * 180.0f / M_PI];
    [_document setRoll:roll * 180.0f / M_PI];
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    const GLfloat kMinScale = 0.2f;
    const GLfloat kMaxScale = 5.0f;
    const GLfloat currentScale = [_document scale];
    const CGFloat deltaY = [theEvent deltaY];
    const CGFloat newScale = MAX(MIN(currentScale + deltaY, kMaxScale), kMinScale);
    [_document setScale:newScale];
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

@end

@interface CModelDocument ()

@property (nonatomic, retain) ArcBallView *arcBallView;

- (void)updateMatrix;

@end

#pragma mark -

@implementation CModelDocument

@synthesize renderer;
@synthesize mainView;
@synthesize roll;
@synthesize pitch;
@synthesize yaw;
@synthesize scale;
@synthesize cameraX;
@synthesize cameraY;
@synthesize cameraZ;
@synthesize lightX;
@synthesize lightY;
@synthesize lightZ;
@synthesize arcBallView = _arcBallView;

- (id)init
    {
    if ((self = [super init]) != NULL)
        {
        renderer = [[COBJRenderer alloc] init];
        
        scale = 1.0;
        
        CMeshLoader *theLoader = [[[CMeshLoader alloc] init] autorelease];
		NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"teapot" withExtension:@"model.plist"];
        self.renderer.mesh = [theLoader loadMeshWithURL:theURL error:NULL];
        
        self.cameraX = self.renderer.camera.position.x;
        self.cameraY = self.renderer.camera.position.y;
        self.cameraZ = self.renderer.camera.position.z;

        self.lightX = self.renderer.light.position.x;
        self.lightY = self.renderer.light.position.y;
        self.lightZ = self.renderer.camera.position.z;
        }
    return self;
    }

- (void)dealloc
    {
    [mainView release];
    [renderer release];
    //
    [super dealloc];
    }

- (NSString *)windowNibName
    {
    return @"CModelDocument";
    }

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
    {
    [super windowControllerDidLoadNib:aController];
    //
    [self.mainView setWantsLayer:YES];
    self.mainView.rendererLayer.renderer = self.renderer;

    self.arcBallView = [[[ArcBallView alloc] initWithFrame:self.mainView.bounds] autorelease];
    self.arcBallView.document = self;
    [self.mainView addSubview:self.arcBallView];
    }

#pragma mark -

- (void)setRoll:(GLfloat)inRoll
    {
    roll = inRoll;
    
    [self updateMatrix];
    }

- (void)setPitch:(GLfloat)inPitch
    {
    pitch = inPitch;
    
    [self updateMatrix];
    }

- (void)setYaw:(GLfloat)inYaw
    {
    yaw = inYaw;
    
    [self updateMatrix];
    }

- (void)setScale:(GLfloat)inScale
    {
    scale = inScale;

    [self updateMatrix];
    }

- (void)setCameraX:(GLfloat)inCameraX
    {
    cameraX = inCameraX;
    
    Vector4 theCameraPosition = self.renderer.camera.position;
    theCameraPosition.x = inCameraX;
    self.renderer.camera.position = theCameraPosition;
    }

- (void)setCameraY:(GLfloat)inCameraY
    {
    cameraY = inCameraY;
    
    Vector4 theCameraPosition = self.renderer.camera.position;
    theCameraPosition.y = inCameraY;
    self.renderer.camera.position = theCameraPosition;
    }

- (void)setCameraZ:(GLfloat)inCameraZ
    {
    cameraZ = inCameraZ;
    
    Vector4 theCameraPosition = self.renderer.camera.position;
    theCameraPosition.z = inCameraZ;
    self.renderer.camera.position = theCameraPosition;
    }

- (void)setLightX:(GLfloat)inLightX
    {
    lightX = inLightX;
    
    Vector4 theLightPosition = self.renderer.light.position;
    theLightPosition.x = inLightX;
    self.renderer.light.position = theLightPosition;
    }

- (void)setLightY:(GLfloat)inLightY
    {
    lightY = inLightY;
    
    Vector4 theLightPosition = self.renderer.light.position;
    theLightPosition.y = inLightY;
    self.renderer.light.position = theLightPosition;
    }

- (void)setLightZ:(GLfloat)inLightZ
    {
    lightZ = inLightZ;
    
    Vector4 theLightPosition = self.renderer.light.position;
    theLightPosition.z = inLightZ;
    self.renderer.light.position = theLightPosition;
    }

    
#pragma mark -

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
    {
    if (outError)
        {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
        }
    return nil;
    }

- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER;
    {
    NSLog(@"%@", typeName);
    if ([typeName isEqualToString:@"obj"])
        {
    //    NSString *theInputFile = [NSString stringWithFormat:@"'%@'", absoluteURL.path];
        char thePath[] = "/tmp/XXXXXXXX";
        NSString *theOutputPath = [NSString stringWithFormat:@"%s/Test.model.plist", mkdtemp(thePath)];
        NSString *theScript = [NSString stringWithFormat:@"OBJConverter --input '%@' --output '%@'", absoluteURL.path, theOutputPath];

        NSLog(@"Running script");
        NSTask *theTask = [[NSTask alloc] init];
        [theTask setLaunchPath:@"/bin/bash"];
        [theTask setArguments:[NSArray arrayWithObjects:@"--login", @"-c", theScript, NULL]];
        [theTask setStandardOutput:[NSFileHandle fileHandleWithNullDevice]];
        [theTask setStandardError:[NSFileHandle fileHandleWithNullDevice]];
        [theTask launch];
        [theTask waitUntilExit];
        NSLog(@"Script Returned: %d", [theTask terminationStatus]);
        
        [theTask release];
        
        CMeshLoader *theLoader = [[[CMeshLoader alloc] init] autorelease];
        NSURL *theURL = [NSURL fileURLWithPath:theOutputPath];
        self.renderer.mesh = [theLoader loadMeshWithURL:theURL error:NULL];
        
    //    if (outError)
    //        {
    //        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    //        }
        return(YES);
        }
    else if ([typeName isEqualToString:@"plist"])
        {
        CMeshLoader *theLoader = [[[CMeshLoader alloc] init] autorelease];
        self.renderer.mesh = [theLoader loadMeshWithURL:absoluteURL error:NULL];
        
    //    if (outError)
    //        {
    //        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
    //        }
        return(YES);
        }
    else
        {
        return(NO);
        }
    }

#pragma mark -

- (void)updateMatrix
    {
    self.renderer.modelTransform = Matrix4Concat(
        Matrix4MakeScale(self.scale, self.scale, self.scale),
        Matrix4FromQuaternion(QuaternionSetEuler(DegreesToRadians(self.yaw), DegreesToRadians(self.pitch), DegreesToRadians(self.roll)))
        );
    }

@end
