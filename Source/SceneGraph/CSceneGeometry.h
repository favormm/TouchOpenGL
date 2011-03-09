//
//  CGeometryNode.h
//  Racing Genes
//
//  Created by Jonathan Wight on 09/23/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CSceneNode.h"

#import "OpenGLIncludes.h"

@class CVertexBufferReference;

@interface CSceneGeometry : CSceneNode {
}

@property (readwrite, nonatomic, retain) CVertexBufferReference *indicesBufferReference;
@property (readwrite, nonatomic, retain) CVertexBufferReference *coordinatesBufferReference;
@property (readwrite, nonatomic, retain) CVertexBufferReference *textureCoordinatesBufferReference;
@property (readwrite, nonatomic, retain) CVertexBufferReference *colorsBufferReference;
@property (readwrite, nonatomic, retain) NSSet *vertexBuffers;

@end
