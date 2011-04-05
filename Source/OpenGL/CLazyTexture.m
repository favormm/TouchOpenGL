//
//  CLazyTexture.m
//  ModelViewer_OSX
//
//  Created by Jonathan Wight on 04/04/11.
//  Copyright 2011 Inkling. All rights reserved.
//

#import "CLazyTexture.h"

#import "OpenGLTypes.h"

@interface CLazyTexture ()
@property (readwrite, nonatomic, assign) BOOL loaded;

//@property (readwrite, nonatomic, assign) GLuint name;
//@property (readwrite, nonatomic, assign) SIntSize size;
//@property (readwrite, nonatomic, assign) GLenum internalFormat;
//@property (readwrite, nonatomic, assign) GLboolean hasAlpha;

- (void)loadWithImage:(CGImageRef)inImage;
@end

#pragma mark -

@implementation CLazyTexture

@synthesize image;
@synthesize loaded;

//@synthesize name;
//@synthesize size;
//@synthesize internalFormat;
//@synthesize hasAlpha;

- (id)initWIthImage:(CGImageRef)inImage;
	{
	if ((self = [super init]) != NULL)
		{
        CFRetain(inImage);
        image = inImage;
		}
	return(self);
	}

- (void)dealloc
    {
    CFRelease(image);
    image = NULL;
    //
    [super dealloc];
    }

- (GLuint)name
    {
    if (self.loaded == NO)
        {
        [self loadWithImage:self.image];
        }
    return([super name]);
    }

//- (SIntSize)size
//    {
//    }

- (GLenum)internalFormat
    {
    if (self.loaded == NO)
        {
        [self loadWithImage:self.image];
        }
    return([super internalFormat]);
    }

- (GLboolean)hasAlpha
    {
    if (self.loaded == NO)
        {
        [self loadWithImage:self.image];
        }
    return([super hasAlpha]);
    }

- (void)loadWithImage:(CGImageRef)inImage
    {
    NSAssert(inImage != NULL, @"Seriously, we need an image!");
    
    CGColorSpaceRef theColorSpace = CGImageGetColorSpace(inImage);
    CGColorSpaceModel theModel = CGColorSpaceGetModel(theColorSpace);
    CGImageAlphaInfo theAlphaInfo = CGImageGetAlphaInfo(inImage);
    size_t theBitsPerComponent = CGImageGetBitsPerComponent(inImage);



    const CGSize theSize = (CGSize){ floor(CGImageGetWidth(inImage)), floor(CGImageGetHeight(inImage)) };

    GLint theFormat = 0;
    GLint theType = 0;

    NSData *theData = NULL;

    // Convert to power of 2    
    SIntSize theDesiredSize = {
        .width = exp2(ceil(log2(theSize.width))),
        .height = exp2(ceil(log2(theSize.height))),
        };
    
    theDesiredSize.width = theDesiredSize.height = MAX(theDesiredSize.width, theDesiredSize.height);
    
    if (theModel == kCGColorSpaceModelRGB && theAlphaInfo == kCGImageAlphaLast && theBitsPerComponent == 8 && theSize.width == theDesiredSize.width && theSize.height == theDesiredSize.height)
        {
        theFormat = GL_RGBA;
        theType = GL_UNSIGNED_BYTE;
        theData = [(NSData *)CGDataProviderCopyData(CGImageGetDataProvider(inImage)) autorelease];
        }
    else
        {
        theFormat = GL_RGBA;
        theType = GL_UNSIGNED_BYTE;
        
        NSLog(@"Warning, converting image. Unknown model (%d), alpha (%d) or bits per component (%ld)", theModel, theAlphaInfo, theBitsPerComponent);
        
        NSMutableData *theMutableData = [NSMutableData dataWithLength:theDesiredSize.width * 4 * theDesiredSize.height];
        theData = theMutableData;
        
        CGColorSpaceRef theColorspace = CGColorSpaceCreateDeviceRGB();
        
        CGContextRef theImageContext = CGBitmapContextCreate([theMutableData mutableBytes], theDesiredSize.width, theDesiredSize.height, 8, theDesiredSize.width * 4, theColorSpace, kCGImageAlphaPremultipliedLast);
        NSAssert(theImageContext != NULL, @"Should not have null context");

        CGContextDrawImage(theImageContext, (CGRect){ .size = { .width = theDesiredSize.width, .height = theDesiredSize.height } }, inImage);
        CGContextRelease(theImageContext);
        
        CGColorSpaceRelease(theColorspace);
        }

    if (theFormat != 0 && theType != 0)
        {
        AssertOpenGLValidContext_();
        
        GLuint theName = 0;

        glGenTextures(1, &theName);
        
        AssertOpenGLNoError_();
        
        glBindTexture(GL_TEXTURE_2D, theName);

        glTexImage2D(GL_TEXTURE_2D, 0, theFormat, (GLsizei)theDesiredSize.width, (GLsizei)theDesiredSize.height, 0, theFormat, theType, theData.bytes);

        glGenerateMipmap(GL_TEXTURE_2D);

        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

        AssertOpenGLNoError_();

        self.name = theName;
        self.size = theDesiredSize;
        self.internalFormat = theFormat;
        self.hasAlpha = YES;

        glBindTexture(GL_TEXTURE_2D, 0);

        AssertOpenGLNoError_();
        } 
        
    self.loaded = YES;
    }



@end
