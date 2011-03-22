//
//  NSData_NumberExtensions.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/19/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "NSData_NumberExtensions.h"


@implementation NSData (NSData_NumberExtensions)

+ (NSData *)dataWithNumbersInString:(NSString *)inString type:(CFNumberType)inType error:(NSError **)outError
    {
    #pragma unused (outError)
    
    NSMutableData *theData = [ NSMutableData data];
    
    NSScanner *theScanner = [NSScanner scannerWithString:inString];
    [theScanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@" \t\r\n|;(){}[],"]];
    
    while ([theScanner isAtEnd] == NO)
        {
        switch (inType)
            {
            case kCFNumberFloat32Type:
            case kCFNumberFloatType:
                {
                float theValue;
                if ([theScanner scanFloat:&theValue])
                    {
                    [theData appendBytes:&theValue length:sizeof(theValue)];
                    }
                }
                break;
            case kCFNumberFloat64Type:
            case kCFNumberDoubleType:
                {
                double theValue;
                if ([theScanner scanDouble:&theValue])
                    {
                    [theData appendBytes:&theValue length:sizeof(theValue)];
                    }
                }
                break;
            default:
                break;
            }

        // TODO support more data types

//    kCFNumberSInt8Type = 1,
//    kCFNumberSInt16Type = 2,
//    kCFNumberSInt32Type = 3,
//    kCFNumberSInt64Type = 4,
//     = 5,
//    kCFNumberFloat64Type = 6,	/* 64-bit IEEE 754 */
//    /* Basic C types */
//    kCFNumberCharType = 7,
//    kCFNumberShortType = 8,
//    kCFNumberIntType = 9,
//    kCFNumberLongType = 10,
//    kCFNumberLongLongType = 11,
//     = 13,
//    /* Other */
//
//    kCFNumberCFIndexType = 14,
//    kCFNumberNSIntegerType = 15,
//
//    kCFNumberCGFloatType = 16,
        }

    return([[theData copy] autorelease]);
    }

@end
