//
//  CMaterial.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CPropertyListRepresentation.h"
#import "OpenGLTypes.h"

@class CTexture;

@interface CMaterial : NSObject <CPropertyListRepresentation> {
    
}

@property (readwrite, nonatomic, retain) NSString *name;
@property (readwrite, nonatomic, assign) Color4f ambientColor;
@property (readwrite, nonatomic, assign) Color4f diffuseColor;
@property (readwrite, nonatomic, assign) Color4f specularColor;
@property (readwrite, nonatomic, retain) CTexture *texture;

@end

