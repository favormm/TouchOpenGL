//
//  COBJRenderer.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CRenderer.h"

@class CLight;

@interface COBJRenderer : CRenderer {
    
}

@property (readwrite, nonatomic, retain) CLight *light;

@end
