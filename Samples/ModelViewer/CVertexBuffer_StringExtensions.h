//
//  CVertexBuffer_StringExtensions.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/18/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CVertexBuffer.h"

@interface CVertexBuffer (CVertexBuffer_StringExtensions)

+ (CVertexBuffer *)vertexBufferWithString:(NSString *)inString target:(GLenum)inTarget usage:(GLenum)inUsage;

@end
