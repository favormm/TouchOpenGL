//
//  CVertexBufferReference.m
//  Racing Gene
//
//  Created by Jonathan Wight on 01/31/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CVertexBufferReference.h"

#import "CVertexBuffer.h"
#import "OpenGLTypes.h"

@interface CVertexBufferReference ()
@property (readwrite, nonatomic, retain) CVertexBuffer *vertexBuffer;

@property (readwrite, nonatomic, assign) GLint size;
@property (readwrite, nonatomic, assign) GLenum type;
@property (readwrite, nonatomic, assign) GLboolean normalized;
@property (readwrite, nonatomic, assign) GLsizei stride;
@property (readwrite, nonatomic, assign) GLsizei offset;

@property (readwrite, nonatomic, assign) GLint rowSize;
@property (readwrite, nonatomic, assign) GLint rowCount;

+ (BOOL)computeRowCount:(GLint *)outRowCount type:(GLenum *)outType size:(GLint *)outSize rowSize:(GLint *)outRowSize vertexBuffer:(CVertexBuffer *)inVertexBuffer fromEncoding:(const char *)inEncoding;
@end

#pragma mark -

@implementation CVertexBufferReference

@synthesize vertexBuffer;
@synthesize size;
@synthesize type;
@synthesize normalized;
@synthesize stride;
@synthesize offset;

@synthesize rowSize;
@synthesize rowCount;

- (id)initWithVertexBuffer:(CVertexBuffer *)inVertexBuffer rowSize:(GLint)inRowSize rowCount:(GLint)inRowCount size:(GLint)inSize type:(GLenum)inType normalized:(GLboolean)inNormalized stride:(GLsizei)inStride offset:(GLsizei)inOffset
    {
    if ((self = [super init]) != NULL)
        {
		NSAssert(inVertexBuffer != NULL, @"We need a vertex buffer.");
        NSAssert(inSize >= 1 && inSize <= 4, @"Size needs to be between 1 & 4");
        NSAssert((size_t)(inRowCount * inRowSize) == inVertexBuffer.data.length, @"Row size * roww count != vertex buffer length");
        NSAssert(inStride == 0 || inStride <= inRowSize, @"Stride should be either 0 or row size");
        NSAssert(inOffset == 0 || inOffset < inStride, @"Offset should be 0 or less then stride");

        vertexBuffer = [inVertexBuffer retain];

        rowSize = inRowSize;
        rowCount = inRowCount;
        size = inSize;
        type = inType;
        normalized = inNormalized;
        stride = inStride;
        offset = inOffset;
        }
    return(self);
    }
    
- (id)initWithVertexBuffer:(CVertexBuffer *)inVertexBuffer rowSize:(GLint)inRowSize rowCount:(GLint)inRowCount size:(GLint)inSize type:(GLenum)inType normalized:(GLboolean)inNormalized
    {
    if ((self = [self initWithVertexBuffer:inVertexBuffer rowSize:inRowSize rowCount:inRowCount size:inSize type:inType normalized:inNormalized stride:0 offset:0]) != NULL)
        {
        }
    return(self);
    }
    
- (void)dealloc
    {
    [vertexBuffer release];
    vertexBuffer = NULL;
    
    [super dealloc];
    }

- (NSString *)description
    {
    return([NSString stringWithFormat:@"%@ (VBO:%@, rowSize:%d, rowCount:%d, size:%d, type:%@, normalized:%d, stride:%d, offset:%d", [super description], self.vertexBuffer, self.rowSize, self.rowCount, self.size, NSStringFromGLenum(self.type), self.normalized, self.stride, self.offset]);
    }

- (void)bind
    {
    AssertOpenGLNoError_();

    glBindBuffer(self.vertexBuffer.target, self.vertexBuffer.name);

    AssertOpenGLNoError_();
    }
    
- (void)use:(GLuint)inAttributeIndex
    {
    [self bind];

    glVertexAttribPointer(inAttributeIndex, self.size, self.type, self.normalized, self.stride, (const GLvoid *)self.offset);

    AssertOpenGLNoError_();
    }

#pragma mark -

- (id)initWithVertexBuffer:(CVertexBuffer *)inVertexBuffer cellEncoding:(char *)inEncoding normalized:(GLboolean)inNormalized stride:(GLsizei)inStride offset:(GLsizei)inOffset
    {
    GLint theRowSize = 0, theRowCount = 0, theSize;
    
    GLenum theType;
    
    
    [[self class] computeRowCount:&theRowCount type:&theType size:&theSize rowSize:&theRowSize vertexBuffer:inVertexBuffer fromEncoding:inEncoding];
    
    if ((self = [self initWithVertexBuffer:inVertexBuffer rowSize:theRowSize rowCount:theRowCount size:theSize type:theType normalized:inNormalized stride:inStride offset:inOffset]) != NULL)
        {
        }
    return(self);
    }
    
- (id)initWithVertexBuffer:(CVertexBuffer *)inVertexBuffer cellEncoding:(char *)inEncoding normalized:(GLboolean)inNormalized;
    {
    if ((self = [self initWithVertexBuffer:inVertexBuffer cellEncoding:inEncoding normalized:inNormalized stride:0 offset:0]) != NULL)
        {
        }
    return(self);
    }

+ (BOOL)computeRowCount:(GLint *)outRowCount type:(GLenum *)outType size:(GLint *)outSize rowSize:(GLint *)outRowSize vertexBuffer:(CVertexBuffer *)inVertexBuffer fromEncoding:(const char *)inEncoding
    {
    NSUInteger theRowSize = 0;
    NSGetSizeAndAlignment(inEncoding, &theRowSize, NULL);
    *outRowSize = (GLint)theRowSize;
    
    *outRowCount = (GLint)([inVertexBuffer.data length] / theRowSize);

    NSString *theCellEncodingString = [NSString stringWithUTF8String:inEncoding];

    NSScanner *theScanner = [NSScanner scannerWithString:theCellEncodingString];
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

        *outSize = (GLint)[theMemberTypes length];
        }
    else
        {
        theResult = [theScanner scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"fdcCsSiI"] intoString:&theMemberTypes];
        NSAssert(theResult == YES, @"Scan failed");

        *outSize = 1;
        }


    // TODO we're assuming all types are the same (e.g. ffff vs fdfd). This is probably a safe assumption but we should assert on bad data anyways.
    if ([theMemberTypes characterAtIndex:0] == 'f')
        {
        *outType = GL_FLOAT;
        }
    else if ([theMemberTypes characterAtIndex:0] == 'd')
        {
        #if TARGET_OS_IPHONE == 1
        NSAssert(NO, @"No GL_DOUBLE");
        #else
        *outType = GL_DOUBLE;
        #endif
        }
    else if ([theMemberTypes characterAtIndex:0] == 'c')
        {
        *outType = GL_BYTE;
        }
    else if ([theMemberTypes characterAtIndex:0] == 'C')
        {
        *outType = GL_UNSIGNED_BYTE;
        }
    else if ([theMemberTypes characterAtIndex:0] == 's')
        {
        *outType = GL_SHORT;
        }
    else if ([theMemberTypes characterAtIndex:0] == 'S')
        {
        *outType = GL_UNSIGNED_SHORT;
        }
    else if ([theMemberTypes characterAtIndex:0] == 'i')
        {
        *outType = GL_INT;
        }
    else if ([theMemberTypes characterAtIndex:0] == 'I')
        {
        *outType = GL_UNSIGNED_INT;
        }
    else
        {
        NSAssert(NO, @"Scan failed");
        }
        
    NSAssert(*outType != 0, @"Type shoudl not be zero.");
    
    return(YES);
    }

@end
