//
//  CVertexBufferReference.m
//  Racing Gene
//
//  Created by Jonathan Wight on 01/31/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CVertexBufferReference.h"

#import "CVertexBuffer.h"

@interface CVertexBufferReference ()
@property (readwrite, nonatomic, retain) CVertexBuffer *vertexBuffer;

@property (readwrite, nonatomic, retain) NSString *cellEncodingString;

@property (readwrite, nonatomic, assign) GLint cellSize;
@property (readwrite, nonatomic, assign) GLint cellCount;

@property (readwrite, nonatomic, assign) GLint size;
@property (readwrite, nonatomic, assign) GLenum type;
@property (readwrite, nonatomic, assign) GLboolean normalized;
@property (readwrite, nonatomic, assign) GLsizei stride;

- (void)update;
@end

#pragma mark -

@implementation CVertexBufferReference

@synthesize vertexBuffer;
@synthesize cellEncodingString;
@synthesize cellSize;
@synthesize cellCount;
@synthesize size;
@synthesize type;
@synthesize normalized;
@synthesize stride;

- (id)initWithVertexBuffer:(CVertexBuffer *)inVertexBuffer cellEncoding:(char *)inEncoding normalized:(GLboolean)inNormalized stride:(GLsizei)inStride;
    {
    if ((self = [super init]) != NULL)
        {
        vertexBuffer = [inVertexBuffer retain];

        cellEncodingString = [[NSString alloc] initWithUTF8String:inEncoding];
        normalized = inNormalized;
        stride = inStride;
        
        cellSize = -1;
        cellCount = -1;
        size = -1;
        type = -1;
        
        //
        [self update];
        }
    return(self);
    }
    
- (void)dealloc
    {
    vertexBuffer = NULL;
    
    [cellEncodingString release];
    cellEncodingString = NULL;
    //
    [super dealloc];
    }

- (NSString *)description
    {
    return([NSString stringWithFormat:@"%@ (VBO:%@, encoding:%@, cellSize:%d, cellCount:%d, size:%d, type:%d, normalized:%d, stride:%d", [super description], self.vertexBuffer, self.cellEncodingString, self.cellSize, self.cellCount, self.size, self.type, self.normalized, self.stride]);
    }
    
- (const char *)cellEncoding
    {
    return([self.cellEncodingString UTF8String]);
    }

- (void)update
    {
    NSUInteger theCellSize = 0;
    NSGetSizeAndAlignment(self.cellEncoding, &theCellSize, NULL);
    cellSize = theCellSize;
    
    cellCount = [vertexBuffer.data length] / cellSize;

//  {CGPoint=dd}
//  i

    NSScanner *theScanner = [NSScanner scannerWithString:self.cellEncodingString];
    theScanner.charactersToBeSkipped = NULL;
    theScanner.caseSensitive = YES;

    NSString *theMemberTypes = NULL;
    
    BOOL theResult = [theScanner scanString:@"{" intoString:NULL];
    if (theResult == YES)
        {
        NSAssert(theResult == YES, @"Scan failed");
        NSString *theTypeName = NULL;
        theResult = [theScanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:&theTypeName];
        NSAssert(theResult == YES, @"Scan failed");
        theResult = [theScanner scanString:@"=" intoString:NULL];
        NSAssert(theResult == YES, @"Scan failed");

        theResult = [theScanner scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"fdcCsSiI"] intoString:&theMemberTypes];
        NSAssert(theResult == YES, @"Scan failed");

        theResult = [theScanner scanString:@"}" intoString:NULL];
        NSAssert(theResult == YES, @"Scan failed");

        self.size = [theMemberTypes length];
        }
    else
        {
        theResult = [theScanner scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"fdcCsSiI"] intoString:&theMemberTypes];
        NSAssert(theResult == YES, @"Scan failed");

        self.size = 1;
        }


    // TODO we're assuming all types are the same (e.g. ffff vs fdfd). This is probably a safe assumption but we should assert on bad data anyways.
    if ([theMemberTypes characterAtIndex:0] == 'f')
        {
        self.type = GL_FLOAT;
        }
    else if ([theMemberTypes characterAtIndex:0] == 'd')
        {
        #if TARGET_OS_IPHONE == 1
        NSAssert(NO, @"No GL_DOUBLE");
        #else
        self.type = GL_DOUBLE;
        #endif
        }
    else if ([theMemberTypes characterAtIndex:0] == 'c')
        {
        self.type = GL_BYTE;
        }
    else if ([theMemberTypes characterAtIndex:0] == 'C')
        {
        self.type = GL_UNSIGNED_BYTE;
        }
    else if ([theMemberTypes characterAtIndex:0] == 's')
        {
        self.type = GL_SHORT;
        }
    else if ([theMemberTypes characterAtIndex:0] == 'S')
        {
        self.type = GL_UNSIGNED_SHORT;
        }
    else if ([theMemberTypes characterAtIndex:0] == 'i')
        {
        self.type = GL_INT;
        }
    else if ([theMemberTypes characterAtIndex:0] == 'I')
        {
        self.type = GL_UNSIGNED_INT;
        }
    else
        {
        NSAssert(NO, @"Scan failed");
        }
        
    NSAssert(self.type != 0, @"Type shoudl not be zero.");
    }

@end
