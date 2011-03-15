//
//  CLibrary.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/14/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CVertexBuffer;

@interface CLibrary : NSObject {
    
}

- (CVertexBuffer *)vertexBufferForName:(NSString *)inName;

@end
