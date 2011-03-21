//
//  COpenGLAssetLibrary.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/14/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OpenGLIncludes.h"

@class CVertexBuffer;
@class CTexture;

@interface COpenGLAssetLibrary : NSObject {
    
}

+ (COpenGLAssetLibrary *)sharedInstance;

- (CVertexBuffer *)vertexBufferForName:(NSString *)inName target:(GLenum)inTarget usage:(GLenum)inUsage;

- (CTexture *)textureForName:(NSString *)inName error:(NSError **)outError;

@end
