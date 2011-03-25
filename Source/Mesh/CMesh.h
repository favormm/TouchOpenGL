//
//  CNewMesh.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/22/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OpenGLTypes.h"
#import "Matrix.h"

@interface CMesh : NSObject {
    
}

@property (readwrite, nonatomic, retain) NSArray *geometries;
@property (readwrite, nonatomic, assign) Vector3 center; // in model space
@property (readwrite, nonatomic, assign) Vector3 p1, p2; // in model space
@property (readwrite, nonatomic, assign) Matrix4 transform;
@end
