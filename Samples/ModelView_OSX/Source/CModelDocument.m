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

@interface CModelDocument ()

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

- (id)init
    {
    if ((self = [super init]) != NULL)
        {
        renderer = [[COBJRenderer alloc] init];
        
        scale = 1.0;
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
    
#pragma mark -

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
    {
    if (outError)
        {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
        }
    return nil;
    }

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
    {
    if (outError)
        {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
        }
    return(YES);
    }

#pragma mark -

- (void)updateMatrix
    {
    self.renderer.projectionTransform = Matrix4Concat(
        Matrix4MakeScale(self.scale, self.scale, self.scale),
        Matrix4FromQuaternion(QuaternionSetEuler(DegreesToRadians(self.yaw), DegreesToRadians(self.pitch), DegreesToRadians(self.roll)))
        );
    }

@end
