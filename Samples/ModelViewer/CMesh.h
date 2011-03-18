//
//  CMesh.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMaterial;
@class CVertexBufferReference;

@interface CMesh : NSObject {
    
}

@property (readwrite, nonatomic, retain) CMaterial *material;
@property (readwrite, nonatomic, retain) CVertexBufferReference *positions;
@property (readwrite, nonatomic, retain) CVertexBufferReference *texCoords;
@property (readwrite, nonatomic, retain) CVertexBufferReference *normals;

@end
