//
//  CGeometry.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/22/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CVertexArrayBuffer;
@class CVertexBufferReference;
@class CMaterial;

@interface CGeometry : NSObject {
    
}

@property (readwrite, nonatomic, retain) CVertexArrayBuffer *vertexArrayBuffer;

@property (readwrite, nonatomic, retain) CVertexBufferReference *indices;
@property (readwrite, nonatomic, retain) CVertexBufferReference *positions;
@property (readwrite, nonatomic, retain) CVertexBufferReference *texCoords;
@property (readwrite, nonatomic, retain) CVertexBufferReference *normals;

@property (readwrite, nonatomic, retain) CMaterial *material;

@end
