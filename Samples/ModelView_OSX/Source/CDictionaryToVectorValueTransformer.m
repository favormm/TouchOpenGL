//
//  CDictionaryToVectorValueTransformer.m
//  ModelViewer_OSX
//
//  Created by Jonathan Wight on 03/29/11.
//  Copyright 2011 Inkling. All rights reserved.
//

#import "CDictionaryToVectorValueTransformer.h"

#import "OpenGLTypes.h"

@implementation CDictionaryToVectorValueTransformer

+ (void)load
    {
    NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
    //
    [self setValueTransformer:[[[self alloc] init] autorelease] forName:@"DictionaryToVectorValueTransformer"];
    //
    [thePool drain];
    }

- (id)transformedValue:(id)value
    {
    Vector4 theSourceVector;
    [value getValue:&theSourceVector];
    NSDictionary *theDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithDouble:theSourceVector.x], @"x",
        [NSNumber numberWithDouble:theSourceVector.y], @"y",
        [NSNumber numberWithDouble:theSourceVector.z], @"z",
        [NSNumber numberWithDouble:theSourceVector.w], @"w",
        NULL];
    return(theDictionary);
    }

- (id)reverseTransformedValue:(id)value
    {
    Vector4 theVector = { 
        .x = [[value valueForKey:@"x"] doubleValue],
        .y = [[value valueForKey:@"y"] doubleValue],
        .z = [[value valueForKey:@"z"] doubleValue],
        .w = [[value valueForKey:@"w"] doubleValue],
        };
    return([NSValue valueWithBytes:&theVector objCType:@encode(Vector4)]);
    }

@end
