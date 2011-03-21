//
//  NSData_NumberExtensions.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/19/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (NSData_NumberExtensions)

+ (NSData *)dataWithNumbersInString:(NSString *)inString type:(CFNumberType)inType error:(NSError **)outError;

@end
