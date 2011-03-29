//
//  Color4fValueTransformer.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/29/11.
//  Copyright 2011 Inkling. All rights reserved.
//

#import "Color4fValueTransformer.h"

#import "Color_OpenGLExtensions.h"

@implementation Color4fValueTransformer

+ (void)load
    {
    NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
    //
    [self setValueTransformer:[[[self alloc] init] autorelease] forName:@"Color4fValueTransformer"];
    //
    [thePool drain];
    }

- (id)transformedValue:(id)value
    {
    Color4f theSourceColor;
    [value getValue:&theSourceColor];
    NSColor *theColor = [NSColor colorWithDeviceRed:theSourceColor.r green:theSourceColor.g blue:theSourceColor.b alpha:theSourceColor.a];
    return(theColor);
    }

- (id)reverseTransformedValue:(id)value
    {
    NSColor *theSourceColor = value;
    Color4f theColor = theSourceColor.color4f;
    NSValue *theValue = [NSValue valueWithBytes:&theColor objCType:@encode(Color4f)];
    return(theValue);
    }

@end
