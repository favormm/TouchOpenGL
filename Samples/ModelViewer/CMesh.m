//
//  CMesh.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CMesh.h"


@implementation CMesh

@synthesize material;
@synthesize positions;
@synthesize texCoords;
@synthesize normals;
@synthesize center;

- (void)dealloc
    {
    [material release];
    material = NULL;
    
    [positions release];
    positions = NULL;
    
    [texCoords release];
    texCoords = NULL;
    
    [normals release];
    normals = NULL;
    //
    [super dealloc];
    }

@end
