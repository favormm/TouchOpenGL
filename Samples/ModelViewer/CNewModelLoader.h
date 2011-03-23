//
//  CNewModelLoader.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/22/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CNewMesh;

@interface CNewModelLoader : NSObject {
    
}

- (CNewMesh *)loadMeshWithURL:(NSURL *)inURL error:(NSError **)outError;

@end
