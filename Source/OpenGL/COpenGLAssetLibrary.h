//
//  COpenGLAssetLibrary.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/14/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OpenGLIncludes.h"
#import <QuartzCore/QuartzCore.h>

@class CVertexBuffer;
@class CTexture;
@class CProgram;

@interface COpenGLAssetLibrary : NSObject {
    
}

+ (COpenGLAssetLibrary *)sharedInstance;

- (CVertexBuffer *)vertexBufferForName:(NSString *)inName target:(GLenum)inTarget usage:(GLenum)inUsage;

- (CProgram *)programForName:(NSString *)inName attributeNames:(NSArray *)inAttributeNames uniformNames:(NSArray *)inUniformNames error:(NSError **)outError;

@end

#pragma mark -

#if TARGET_OS_IPHONE

@interface EAGLContext (EAGLContext_LibraryExtensions)

@property (readonly, nonatomic, retain) COpenGLAssetLibrary *library;

@end

#endif /* #if TARGET_OS_IPHONE */