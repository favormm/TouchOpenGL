//
//  CNewMesh.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/22/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CNewMesh.h"


@implementation CNewMesh

@synthesize geometries;
@synthesize center;
@synthesize p1, p2;
@synthesize transform;

- (void)dealloc
    {
    [geometries release];
    geometries = NULL;
    //
    [super dealloc];
    }

@end
