//
//  UIColor_OpenGLExtensions.m
//  SketchTest
//
//  Created by Jonathan Wight on 02/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "UIColor_OpenGLExtensions.h"

#import <CoreGraphics/CoreGraphics.h>

@implementation UIColor (UIColor_OpenGLExtensions)

- (Color4f)color4f
	{
    Color4f theColor;
    CGColorRef theCGColor = self.CGColor;
    
    CGColorSpaceRef theColorSpace = CGColorGetColorSpace(theCGColor);
    CGColorSpaceModel theModel = CGColorSpaceGetModel(theColorSpace);
    if (theModel == kCGColorSpaceModelRGB)
        {
        const CGFloat *theComponents = CGColorGetComponents(theCGColor);
        theColor = (Color4f){ theComponents[0], theComponents[1], theComponents[2], CGColorGetAlpha(theCGColor)  };
        }
    else if (theModel == kCGColorSpaceModelMonochrome)
        {
        const CGFloat *theComponents = CGColorGetComponents(theCGColor);
        theColor = (Color4f){ theComponents[0], theComponents[0], theComponents[0], CGColorGetAlpha(theCGColor)  };
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
