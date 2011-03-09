//
//  CFrameBuffer.h
//  SketchTest
//
//  Created by Jonathan Wight on 02/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OpenGLIncludes.h"

@class CRenderBuffer;
@class CTexture;

@interface CFrameBuffer : NSObject {
    
}

@property (readonly, nonatomic, assign) GLuint name;
@property (readonly, nonatomic, assign) BOOL complete;

- (void)bind;

- (void)attachRenderBuffer:(CRenderBuffer *)inRenderBuffer attachment:(GLenum)inAttachment;
- (void)attachTexture:(CTexture *)inTexture attachment:(GLenum)inAttachment;


@end
