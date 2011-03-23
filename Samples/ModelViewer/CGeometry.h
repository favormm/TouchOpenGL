//
//  CGeometry.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/22/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CVertexBufferReference;

@interface CGeometry : NSObject {
    
}


@property (readwrite, nonatomic, retain) CVertexBufferReference *indices;
@property (readwrite, nonatomic, retain) CVertexBufferReference *positions;
@property (readwrite, nonatomic, retain) CVertexBufferReference *texCoords;
@property (readwrite, nonatomic, retain) CVertexBufferReference *normals;

@end
