//
//  CNewMesh.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/22/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OpenGLTypes.h"

@interface CNewMesh : NSObject {
    
}

@property (readwrite, nonatomic, retain) NSArray *geometries;
@property (readwrite, nonatomic, assign) Vector3 center; // in model space

@end
