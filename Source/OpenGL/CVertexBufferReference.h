//
//  CVertexBufferReference.h
//  Racing Gene
//
//  Created by Jonathan Wight on 01/31/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OpenGLIncludes.h"

@class CVertexBuffer;

@interface CVertexBufferReference : NSObject {
}

@property (readonly, nonatomic, retain) CVertexBuffer *vertexBuffer;

@property (readonly, nonatomic, assign) const char *cellEncoding;
@property (readonly, nonatomic, assign) GLint rowSize;
@property (readonly, nonatomic, assign) GLint rowCount;

@property (readonly, nonatomic, assign) GLint size;
@property (readonly, nonatomic, assign) GLenum type;
@property (readonly, nonatomic, assign) GLboolean normalized;
@property (readonly, nonatomic, assign) GLsizei stride;
@property (readonly, nonatomic, assign) GLsizei offset;

- (id)initWithVertexBuffer:(CVertexBuffer *)inVertexBuffer rowSize:(GLint)inRowSize rowCount:(GLint)inRowCount size:(GLint)inSize type:(GLenum)inType normalized:(GLboolean)inNormalized stride:(GLsizei)inStride offset:(GLsizei)inOffset;
- (id)initWithVertexBuffer:(CVertexBuffer *)inVertexBuffer rowSize:(GLint)inRowSize rowCount:(GLint)inRowCount size:(GLint)inSize type:(GLenum)inType normalized:(GLboolean)inNormalized;

- (id)initWithVertexBuffer:(CVertexBuffer *)inVertexBuffer cellEncoding:(char *)inEncoding normalized:(GLboolean)inNormalized stride:(GLsizei)inStride offset:(GLsizei)inOffset;
- (id)initWithVertexBuffer:(CVertexBuffer *)inVertexBuffer cellEncoding:(char *)inEncoding normalized:(GLboolean)inNormalized;

- (void)use:(GLuint)inAttributeIndex;

@end
