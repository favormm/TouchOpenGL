//
//  Color_OpenGLExtensions.m
//  PopTipEditor
//
//  Created by Aaron Golden on 3/21/11,
//  based on UIColor_OpenGLExtensions
//  created by Jonathan Wight on 02/15/11.
//
//  Copyright 2011 Inkling. All rights reserved.
//

#import "Color_OpenGLExtensions.h"

#if TARGET_OS_IPHONE
#import <CoreGraphics/CoreGraphics.h>
@implementation UIColor (UIColor_OpenGLExtensions)
#elif TARGET_OS_MAC
@implementation NSColor (NSColor_OpenGLExtensions)
#endif

- (Color4f)color4f
{
    Color4f theColor;
#if TARGET_OS_IPHONE
    CGColorRef theCGColor = self.CGColor;
    CGColorSpaceRef theColorSpace = CGColorGetColorSpace(theCGColor);
    CGColorSpaceModel theModel = CGColorSpaceGetModel(theColorSpace);
    BOOL isRGB = (theModel == kCGColorSpaceModelRGB);
    BOOL isMonochrome = (theModel == kCGColorSpaceModelMonochrome);
#elif TARGET_OS_MAC
    NSColorSpace *theColorSpace = [self colorSpace];
    NSColorSpaceModel theModel = [theColorSpace colorSpaceModel];
    BOOL isRGB = (theModel == NSRGBColorSpaceModel);
    BOOL isMonochrome = (theModel == NSGrayColorSpaceModel);
#endif
    if (isRGB)
    {
#if TARGET_OS_IPHONE
        const CGFloat *theComponents = CGColorGetComponents(theCGColor);
        theColor = (Color4f){ theComponents[0], theComponents[1], theComponents[2], CGColorGetAlpha(theCGColor) };
#elif TARGET_OS_MAC
        CGFloat theComponents[4];
        [self getComponents:theComponents];
        theColor = (Color4f){ theComponents[0], theComponents[1], theComponents[2], theComponents[3] };
#endif
    }
    else if (isMonochrome)
    {
#if TARGET_OS_IPHONE
        const CGFloat *theComponents = CGColorGetComponents(theCGColor);
        theColor = (Color4f){ theComponents[0], theComponents[0], theComponents[0], CGColorGetAlpha(theCGColor) };
#elif TARGET_OS_IPHONE
        CGFloat theComponents[2];
        [self getComponents:theComponents];
        theColor = (Color4f){ theComponents[0], theComponents[0], theComponents[0], theComponents[1] };
#endif
    }
    else
    {
        NSAssert(NO, @"Unknown color model");
    }
    return(theColor);
}

- (Color4ub)color4ub
{
    Color4f theColor4f = self.color4f;
	Color4ub theColor = { theColor4f.r * 255.0, theColor4f.g * 255.0, theColor4f.b * 255.0, theColor4f.a * 255.0 };
	return(theColor);
}

@end
