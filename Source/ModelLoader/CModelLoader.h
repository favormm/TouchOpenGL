//
//  CModelLoader.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/09/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CScene;

@interface CModelLoader : NSObject {
    
}

- (CScene *)load:(NSURL *)inURL error:(NSError **)outError;

@end
