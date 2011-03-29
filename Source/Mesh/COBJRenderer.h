//
//  COBJRenderer.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CRenderer.h"

#import "OpenGLTypes.h"

@class CLight;
@class CMaterial;

@interface COBJRenderer : CRenderer {
    
}

@property (readwrite, nonatomic, retain) CLight *light;
@property (readwrite, nonatomic, retain) CMaterial *defaultMaterial;
@property (readwrite, nonatomic, assign) Matrix4 modelTransform;


@end
