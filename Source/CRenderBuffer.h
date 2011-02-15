//
//  CRenderBuffer.h
//  SketchTest
//
//  Created by Jonathan Wight on 02/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <QuartzCore/QuartzCore.h>

#import "OpenGLIncludes.h"
#import "OpenGLTypes.h"

@interface CRenderBuffer : NSObject {
    
}

@property (readonly, nonatomic, assign) GLuint name;
@property (readonly, nonatomic, assign) SIntSize size;

- (void)bind;

- (void)storage:(GLenum)inIntermalFormat size:(SIntSize)inSize;

- (void)storageFromContext:(EAGLContext *)inContext drawable:(id <EAGLDrawable>)inDrawable;


@end
