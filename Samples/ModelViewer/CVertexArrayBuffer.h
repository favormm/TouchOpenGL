//
//  CVertexArrayBuffer.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/24/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OpenGLTypes.h"

@interface CVertexArrayBuffer : NSObject {
    
}

@property (readonly, nonatomic, assign) GLuint name;
@property (readwrite, nonatomic, assign) BOOL populated;

- (void)bind;
- (void)unbind;

@end
