//
//  CVertexBuffer_StringExtensions.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/18/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CVertexBuffer_StringExtensions.h"

@implementation CVertexBuffer (CVertexBuffer_StringExtensions)

+ (CVertexBuffer *)vertexBufferWithString:(NSString *)inString target:(GLenum)inTarget usage:(GLenum)inUsage
    {
    NSMutableData *theData = [ NSMutableData data];
    
    NSScanner *theScanner = [NSScanner scannerWithString:inString];
    [theScanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@" \t\r\n|;(){}[],"]];
    
    while ([theScanner isAtEnd] == NO)
        {
        float theFloat;
        if ([theScanner scanFloat:&theFloat])
            {
            GLfloat theGLFloat = theFloat;
            [theData appendBytes:&theGLFloat length:sizeof(theGLFloat)];
            }
        else
            {
            break;
            }
        }
    
    return([[[CVertexBuffer alloc] initWithTarget:inTarget usage:inUsage data:theData] autorelease]);    
    }

@end
