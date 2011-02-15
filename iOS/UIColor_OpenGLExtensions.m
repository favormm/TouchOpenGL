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

//- (Color4f)color4f
//	{
//	}
	
- (Color4ub)color4ub
	{
    // TODO we assume RGB. This is dodgy.
    CGColorRef theCGColor = self.CGColor;
    const CGFloat *theComponents = CGColorGetComponents(theCGColor);
	Color4ub theColor = { theComponents[0] / 255.0, theComponents[1] / 255.0, theComponents[2] / 255.0, CGColorGetAlpha(theCGColor) / 255.0  };
	return(theColor);
	}

@end
