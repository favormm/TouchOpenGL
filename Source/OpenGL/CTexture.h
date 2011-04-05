//
//  CTexture.h
//  Racing Genes
//
//  Created by Jonathan Wight on 09/06/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OpenGLIncludes.h"
#import "OpenGLTypes.h"

@interface CTexture : NSObject {
}

@property (readwrite, nonatomic, assign) GLuint name;
@property (readwrite, nonatomic, assign) SIntSize size;
@property (readwrite, nonatomic, assign) GLenum internalFormat;
@property (readwrite, nonatomic, assign) GLboolean hasAlpha;

- (id)initWithName:(GLuint)inName size:(SIntSize)inSize;

- (BOOL)isValid;

@end
