//
//  CImageTextureLoader.m
//  Dwarfs
//
//  Created by Jonathan Wight on 09/14/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CImageTextureLoader.h"

#if TARGET_OS_IPHONE == 1
#import <OpenGLES/ES2/gl.h>
#else
#import <OpenGL/OpenGL.h>
#endif

#import "CTexture.h"

@implementation CImageTextureLoader

@synthesize scaleToNextLargestPowerOfTwo;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
		scaleToNextLargestPowerOfTwo = YES;
		}
	return(self);
	}

- (CTexture *)textureWithData:(NSData *)inData error:(NSError **)outError
    {
    UIImage *theImage = [UIImage imageWithData:inData];
    CTexture *theTexture = [self textureWithImage:theImage error:outError];
    return(theTexture);
    }

- (CTexture *)textureWithPath:(NSString *)inPath error:(NSError **)outError
    {
    UIImage *theImage = [UIImage imageWithContentsOfFile:inPath];
    CTexture *theTexture = [self textureWithImage:theImage error:outError];
    return(theTexture);
    }

- (CTexture *)textureWithImageNamed:(NSString *)inImageName error:(NSError **)outError;
    {
    return([self textureWithImage:[UIImage imageNamed:inImageName] error:outError]);
    }

- (CTexture *)textureWithImage:(UIImage *)inImage error:(NSError **)outError;
    {
    CGImageRef theImageRef = [inImage CGImage];
    
    CGColorSpaceRef theColorSpace = CGImageGetColorSpace(theImageRef);
    CGColorSpaceModel theModel = CGColorSpaceGetModel(theColorSpace);
    CGImageAlphaInfo theAlphaInfo = CGImageGetAlphaInfo(theImageRef);
    size_t theBitsPerComponent = CGImageGetBitsPerComponent(theImageRef);
	CGSize theSize = inImage.size;

//	NSLog(@"%g, %g", theSize.width, theSize.height);

    GLint theFormat = 0;
    GLint theType = 0;

    NSData *theData = NULL;

    if (theModel == kCGColorSpaceModelRGB && theAlphaInfo == kCGImageAlphaLast && theBitsPerComponent == 8)
        {
        theFormat = GL_RGBA;
        theType = GL_UNSIGNED_BYTE;
        theData = [(NSData *)CGDataProviderCopyData(CGImageGetDataProvider(theImageRef)) autorelease];
        }
    else
        {
        theFormat = GL_RGBA;
        theType = GL_UNSIGNED_BYTE;

		if (0)
			{
			NSLog(@"INFO: Unknown model (%d), alpha (%d) or bits per component (%ld). Converting image.", theModel, theAlphaInfo, theBitsPerComponent);
			}
        
        NSMutableData *theMutableData = [NSMutableData dataWithLength:theSize.width * 4 * theSize.height];
        theData = theMutableData;
        CGContextRef theImageContext = CGBitmapContextCreate([theMutableData mutableBytes], theSize.width, theSize.height, 8, theSize.width * 4, CGImageGetColorSpace(theImageRef), kCGImageAlphaPremultipliedLast);

        CGContextDrawImage(theImageContext, (CGRect){ .size = theSize }, theImageRef);
        CGContextRelease(theImageContext);
        }

    if (theFormat != 0 && theType != 0)
        {
        GLuint theName = 0;
        glGenTextures(1, &theName);
        glBindTexture(GL_TEXTURE_2D, theName);

        NSAssert(theData.length == CGImageGetWidth(theImageRef) * 4 * CGImageGetHeight(theImageRef), @"Image data wrong length");

        glTexImage2D(GL_TEXTURE_2D, 0, theFormat, CGImageGetWidth(theImageRef), CGImageGetHeight(theImageRef), 0, theFormat, theType, theData.bytes);

//        glGenerateMipmap(GL_TEXTURE_2D);

        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

        GLenum theError = glGetError();
        if (theError != GL_NO_ERROR)
            {
            NSLog(@"Image Loader Error?: %x", theError);
            }

        glBindTexture(GL_TEXTURE_2D, 0);
        
        CTexture *theTexture = [[[CTexture alloc] initWithName:theName width:theSize.width height:theSize.height] autorelease];
        return(theTexture);
        } 

    return(NULL);
    }

@end
