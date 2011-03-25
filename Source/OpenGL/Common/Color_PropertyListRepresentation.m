//
//  UIColor_PropertyListRepresentation.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/21/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "Color_PropertyListRepresentation.h"

#if TARGET_OS_IPHONE
@implementation UIColor (UIColor_PropertyListRepresentation)
#elif TARGET_OS_MAC
@implementation NSColor (NSColor_PropertyListRepresentation)
#endif

- (id)initWithPropertyListRepresentation:(id)inRepresentation error:(NSError **)outError;
    {
    #pragma unused (outError)
    
    CGFloat theAlpha = 1.0;
    
    NSArray *theComponents = NULL;
    if ([inRepresentation isKindOfClass:[NSArray class]])
        {
        theComponents = inRepresentation;
        }
    else if ([inRepresentation isKindOfClass:[NSString class]])
        {
        theComponents = [inRepresentation componentsSeparatedByString:@","];
        }
    else
        {
        NSAssert(NO, @"Can only handle arrays or strings.");
        }
    
    CGFloat theRed = [[theComponents objectAtIndex:0] floatValue];
    CGFloat theGreen = [[theComponents objectAtIndex:1] floatValue];
    CGFloat theBlue = [[theComponents objectAtIndex:2] floatValue];
    if ([theComponents count] == 4)
        {
        theAlpha = [[theComponents objectAtIndex:3] floatValue];
        }

	if ((self = [self initWithRed:theRed green:theGreen blue:theBlue alpha:theAlpha]) != NULL)
        {
		}
	return(self);
	}


@end
