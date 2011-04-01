//
//  CLight.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/29/11.
//  Copyright 2011 Inkling. All rights reserved.
//

#import "CLight.h"


@implementation CLight

@synthesize ambientColor;
@synthesize diffuseColor;
@synthesize specularColor;
@synthesize position;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        ambientColor = (Color4f){ 0.5, 0.5, 0.5, 1.0 };
        diffuseColor = (Color4f){ 0.5, 0.5, 0.5, 1.0 };
        specularColor = (Color4f){ 0.5, 0.5, 0.5, 1.0 };
        position = (Vector4){ 0.0, 0.0, 0.0, 0.0 };
		}
	return(self);
	}


@end
