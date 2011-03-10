//
//  CSceneGraphRenderer.h
//  Racing Gene
//
//  Created by Jonathan Wight on 01/31/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CRenderer.h"

#import "OpenGLTypes.h"

@class CScene;
@class CSceneStyle;

@interface CSceneGraphRenderer : CRenderer {
}

@property (readwrite, nonatomic, retain) CScene *sceneGraph;

@property (readwrite, nonatomic, assign) Matrix4 transform;;

@property (readwrite, nonatomic, retain) NSMutableArray *styleStack;
@property (readonly, nonatomic, retain) CSceneStyle *mergedStyle;

- (id)initWithSceneGraph:(CScene *)inSceneGraph;

@end
