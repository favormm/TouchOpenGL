//
//  CGeometry.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/22/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CGeometry.h"

@implementation CGeometry

@synthesize indices;
@synthesize positions;
@synthesize texCoords;
@synthesize normals;

- (void)dealloc
    {
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
    [super dealloc];
    }

@end
