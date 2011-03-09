//
//  NSColor_OpenGLExtensions.m
//  Racing Gene
//
//  Created by Jonathan Wight on 02/05/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "NSColor_OpenGLExtensions.h"

@implementation NSColor (NSColor_OpenGLExtensions)

- (Color4f)color4f
	{
	NSColor *theRGBColor = [self colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	Color4f theColor = { theRGBColor.redComponent, theRGBColor.greenComponent, theRGBColor.blueComponent, theRGBColor.alphaComponent };
	return(theColor);
	}
	
- (Color4ub)color4ub
	{
	NSColor *theRGBColor = [self colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	Color4ub theColor = { theRGBColor.redComponent * 255.0, theRGBColor.greenComponent * 255.0, theRGBColor.blueComponent * 255.0, theRGBColor.alphaComponent * 255.0 };
	return(theColor);
	}

@end
