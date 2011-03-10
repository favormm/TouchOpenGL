//
//  CSceneGraphNode.h
//  Racing Genes
//
//  Created by Jonathan Wight on 09/23/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OpenGLTypes.h"

@class CSceneGraphRenderer;
@class CSceneStyle;

@interface CSceneNode : NSObject {
}

@property (readonly, nonatomic, assign) CSceneNode *supernode;
@property (readwrite, nonatomic, assign) Matrix4 transform;
@property (readwrite, nonatomic, retain) CSceneStyle *style;
@property (readonly, nonatomic, retain) NSArray *subnodes;

- (void)prerender:(CSceneGraphRenderer *)inRenderer;
- (void)render:(CSceneGraphRenderer *)inRenderer;
- (void)postrender:(CSceneGraphRenderer *)inRenderer;

- (void)addSubnode:(CSceneNode *)inSubnode;

- (void)dump;

@end
