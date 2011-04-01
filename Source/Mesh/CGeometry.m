//
//  CGeometry.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/22/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CGeometry.h"

#import "CVertexArrayBuffer.h"

@implementation CGeometry

@synthesize vertexArrayBuffer;
@synthesize indices;
@synthesize positions;
@synthesize texCoords;
@synthesize normals;
@synthesize material;

- (void)dealloc
    {
    [vertexArrayBuffer release];
    vertexArrayBuffer = NULL;
    
    [indices release];
	indices = NULL;
	//
	[positions release];
	positions = NULL;
	//
	[texCoords release];
	texCoords = NULL;
	//
	[normals release];
	normals = NULL;
    //
    [material release];
    material = NULL;
    //
    [super dealloc];
    }

- (CVertexArrayBuffer *)vertexArrayBuffer
    {
    #if TARGET_OS_IPHONE
    if (vertexArrayBuffer == NULL)
        {
        vertexArrayBuffer = [[CVertexArrayBuffer alloc] init];
        }
    return(vertexArrayBuffer);
    #else
    return(NULL);
    #endif /* TARGET_OS_IPHONE */
    }


@end
