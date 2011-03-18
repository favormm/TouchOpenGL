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

@end
