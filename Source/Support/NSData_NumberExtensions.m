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
			case kCFNumberSInt8Type:
                {
                NSInteger theInteger;
                if ([theScanner scanInteger:&theInteger])
                    {
					SInt8 theValue = theInteger;
                    [theData appendBytes:&theValue length:sizeof(theValue)];
                    }
                }
                break;
			case kCFNumberSInt16Type:
                {
                NSInteger theInteger;
                if ([theScanner scanInteger:&theInteger])
                    {
					SInt16 theValue = theInteger;
                    [theData appendBytes:&theValue length:sizeof(theValue)];
                    }
                }
                break;
			case kCFNumberSInt32Type:
                {
                NSInteger theInteger;
                if ([theScanner scanInteger:&theInteger])
                    {
					SInt32 theValue = (SInt32)theInteger;
                    [theData appendBytes:&theValue length:sizeof(theValue)];
                    }
                }
                break;
			case kCFNumberSInt64Type:
                {
                NSInteger theInteger;
                if ([theScanner scanInteger:&theInteger])
                    {
					SInt64 theValue = theInteger;
                    [theData appendBytes:&theValue length:sizeof(theValue)];
                    }
                }
                break;
			case kCFNumberCharType:
                {
                NSInteger theInteger;
                if ([theScanner scanInteger:&theInteger])
                    {
					char theValue = theInteger;
                    [theData appendBytes:&theValue length:sizeof(theValue)];
                    }
                }
                break;
			case kCFNumberShortType:
                {
                NSInteger theInteger;
                if ([theScanner scanInteger:&theInteger])
                    {
					short theValue = theInteger;
                    [theData appendBytes:&theValue length:sizeof(theValue)];
                    }
                }
                break;
			case kCFNumberIntType:
                {
                int theValue;
                if ([theScanner scanInt:&theValue])
                    {
                    [theData appendBytes:&theValue length:sizeof(theValue)];
                    }
                }
                break;
			case kCFNumberLongType:
                {
                NSInteger theInteger;
                if ([theScanner scanInteger:&theInteger])
                    {
					long theValue = theInteger;
                    [theData appendBytes:&theValue length:sizeof(theValue)];
                    }
                }
                break;
			case kCFNumberLongLongType:
                {
                long long theValue;
                if ([theScanner scanLongLong:&theValue])
                    {
                    [theData appendBytes:&theValue length:sizeof(theValue)];
                    }
                }
                break;
			case kCFNumberCFIndexType:
                {
                NSInteger theInteger;
                if ([theScanner scanInteger:&theInteger])
                    {
					CFIndex theValue = theInteger;
                    [theData appendBytes:&theValue length:sizeof(theValue)];
                    }
                }
                break;
			case kCFNumberNSIntegerType:
                {
                NSInteger theValue;
                if ([theScanner scanInteger:&theValue])
                    {
                    [theData appendBytes:&theValue length:sizeof(theValue)];
                    }
                }
                break;
			case kCFNumberCGFloatType:
                {
                double theDouble;
                if ([theScanner scanDouble:&theDouble])
                    {
					CGFloat theValue = theDouble;
                    [theData appendBytes:&theValue length:sizeof(theValue)];
                    }
                }
                break;
            default:
				{
				if (outError)
					{
					}
				return(NULL);
				}
                break;
            }

        // TODO support more data types

        }

    return([[theData copy] autorelease]);
    }

@end
