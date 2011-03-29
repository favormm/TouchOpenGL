//
//  CLight.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/29/11.
//  Copyright 2011 Inkling. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OpenGLTypes.h"

@interface CLight : NSObject {

}

@property (readwrite, nonatomic, assign) Color4f ambientColor;
@property (readwrite, nonatomic, assign) Color4f diffuseColor;
@property (readwrite, nonatomic, assign) Color4f specularColor;
@property (readwrite, nonatomic, assign) Vector4 position;

@end
