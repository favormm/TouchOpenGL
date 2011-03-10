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
@property (readonly, nonatomic, retain) CSceneStyle *mergedStyle;
@property (readonly, nonatomic, assign) Matrix4 transform;

- (id)initWithSceneGraph:(CScene *)inSceneGraph;

- (void)pushStyle:(CSceneStyle *)inStyle;
- (void)popStyle:(CSceneStyle *)inStyle;

- (void)pushTransform:(Matrix4)inTransform;
- (void)popTransform:(Matrix4)inTransform;

@end
