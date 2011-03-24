//
//  CRenderer_Extensions.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CRenderer.h"

#import "OpenGLTypes.h"

@interface CRenderer (CRenderer_Extensions)

- (void)drawAxes:(Matrix4)inTransform;
- (void)drawBoundingBox:(Matrix4)inTransform v1:(Vector3)inV1 v2:(Vector3)inV2;

@end
