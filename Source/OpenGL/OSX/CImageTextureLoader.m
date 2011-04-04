//
//  CImageTextureLoader.m
//  Racing Genes
//
//  Created by Jonathan Wight on 09/14/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CImageTextureLoader.h"

#import <OpenGL/OpenGL.h>

#import "CTexture.h"

@implementation CImageTextureLoader

- (CTexture *)textureWithData:(NSData *)inData error:(NSError **)outError
    {
    NSImage *theImage = [[[NSImage alloc] initWithData:inData] autorelease];
    CTexture *theTexture = [self textureWithImage:theImage error:outError];
    return(theTexture);
    }

- (CTexture *)textureWithPath:(NSString *)inPath error:(NSError **)outError
    {
    NSImage *theImage = [[[NSImage alloc] initWithContentsOfFile:inPath] autorelease];
    CTexture *theTexture = [self textureWithImage:theImage error:outError];
    return(theTexture);
    }

- (CTexture *)textureWithImage:(NSImage *)inImage error:(NSError **)outError;
    {
    NSAssert(inImage != NULL, @"Seriously, we need an image!");
    
    CGImageRef theImageRef = [inImage CGImageForProposedRect:NULL context:NULL hints:NULL];
    
    CGColorSpaceRef theColorSpace = CGImageGetColorSpace(theImageRef);
    CGColorSpaceModel theModel = CGColorSpaceGetModel(theColorSpace);
    CGImageAlphaInfo theAlphaInfo = CGImageGetAlphaInfo(theImageRef);
    size_t theBitsPerComponent = CGImageGetBitsPerComponent(theImageRef);

    CGSize theSize = (CGSize){ floor(inImage.size.width), floor(inImage.size.width) };

    GLint theFormat = 0;
    GLint theType = 0;

    NSData *theData = NULL;

    // Convert to power of 10
    
    CGSize theDesiredSize = (CGSize){
        .width = exp2(ceil(log2(theSize.width))),
        .height = exp2(ceil(log2(theSize.height))),
        };
    
    theDesiredSize.width = theDesiredSize.height = MAX(theDesiredSize.width, theDesiredSize.height);
    
    NSLog(@"%g %g", theSize.width, theSize.height);
    NSLog(@"%g %g", theDesiredSize.width, theDesiredSize.height);


    if (theModel == kCGColorSpaceModelRGB && theAlphaInfo == kCGImageAlphaLast && theBitsPerComponent == 8 && CGSizeEqualToSize(theSize, theDesiredSize))
        {
        theFormat = GL_RGBA;
        theType = GL_UNSIGNED_BYTE;
        theData = [(NSData *)CGDataProviderCopyData(CGImageGetDataProvider(theImageRef)) autorelease];
        }
    else
        {
        theFormat = GL_RGBA;
        theType = GL_UNSIGNED_BYTE;
        
        theSize = theDesiredSize;

        NSLog(@"Warning, converting image. Unknown model (%d), alpha (%d) or bits per component (%ld)", theModel, theAlphaInfo, theBitsPerComponent);
        
        NSMutableData *theMutableData = [NSMutableData dataWithLength:theSize.width * 4 * theSize.height];
        theData = theMutableData;
        
        CGColorSpaceRef theColorspace = CGColorSpaceCreateDeviceRGB();
        
        CGContextRef theImageContext = CGBitmapContextCreate([theMutableData mutableBytes], theSize.width, theSize.height, 8, theSize.width * 4, theColorSpace, kCGImageAlphaPremultipliedLast);
        NSAssert(theImageContext != NULL, @"Should not have null context");

        CGContextDrawImage(theImageContext, (CGRect){ .size = theSize }, theImageRef);
        CGContextRelease(theImageContext);
        
        CGColorSpaceRelease(theColorspace);
        }

    if (theFormat != 0 && theType != 0)
        {
        GLuint theName = 0;
        glGenTextures(1, &theName);
        glBindTexture(GL_TEXTURE_2D, theName);

        glTexImage2D(GL_TEXTURE_2D, 0, theFormat, (GLsizei)CGImageGetWidth(theImageRef), (GLsizei)CGImageGetHeight(theImageRef), 0, theFormat, theType, theData.bytes);

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
