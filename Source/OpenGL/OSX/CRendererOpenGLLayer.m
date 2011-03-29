//
//  CRendererOpenGLLayer.m
//  Racing Gene
//
//  Created by Jonathan Wight on 01/31/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CRendererOpenGLLayer.h"

#import "CRenderer.h"

@interface CRendererOpenGLLayer ()
@property (readwrite, nonatomic, assign) BOOL setup;
@end

#pragma mark -

@implementation CRendererOpenGLLayer

@synthesize renderer;

@synthesize setup;

- (id)init
    {
    if ((self = [super init]) != NULL)
        {
        self.asynchronous = YES;
        }
    return(self);
    }

- (void)dealloc
    {
    [renderer release];
    renderer = NULL;
    //
    [super dealloc];
    }

- (CGLPixelFormatObj)copyCGLPixelFormatForDisplayMask:(uint32_t)mask
    {
    CGLPixelFormatAttribute thePixelFormatAttributes[] = {
        kCGLPFADisplayMask, mask,
        kCGLPFAAccelerated,
        kCGLPFAColorSize, 8,
        kCGLPFAAlphaSize, 8,
        kCGLPFADepthSize, 16,
        kCGLPFANoRecovery,
        kCGLPFAMultisample,
        kCGLPFASupersample,
        kCGLPFASampleAlpha,
        0
        };
    CGLPixelFormatObj thePixelFormatObject = NULL;
    GLint theNumberOfPixelFormats = 0;
    CGLChoosePixelFormat(thePixelFormatAttributes, &thePixelFormatObject, &theNumberOfPixelFormats);
    if (thePixelFormatObject == NULL)
        {
        NSLog(@"Error: Could not choose pixel format!");
        }
    return(thePixelFormatObject);
    }

//- (CGLContextObj)copyCGLContextForPixelFormat:(CGLPixelFormatObj)pixelFormat
//    {
//    GLint depth = -14;
//    CGLDescribePixelFormat(pixelFormat, 0, kCGLPFADepthSize, &depth);
//    NSLog(@"> %d", depth);
//	return([super copyCGLContextForPixelFormat:pixelFormat]);
//    }

- (void)drawInCGLContext:(CGLContextObj)ctx pixelFormat:(CGLPixelFormatObj)pf forLayerTime:(CFTimeInterval)t displayTime:(const CVTimeStamp *)ts
    {
    CGLSetCurrentContext(ctx);
    
    if (self.setup == NO)
        {
        [self.renderer setup];
        self.setup = YES;
        }
    
    [self.renderer clear];

    [self.renderer prerender];
    [self.renderer render];
    [self.renderer postrender];

    [super drawInCGLContext:ctx pixelFormat:pf forLayerTime:t displayTime:ts];
    }


@end
