//
//  CSceneGeometryBrush.h
//  Racing Gene
//
//  Created by Jonathan Wight on 02/05/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CSceneNode.h"

#import "OpenGLTypes.h"
#import "CSceneGeometry.h"

@interface CSceneGeometryBrush : CSceneNode {
}

@property (readwrite, nonatomic, assign) GLenum type;
@property (readwrite, nonatomic, assign) CSceneGeometry *geometry;

@end
