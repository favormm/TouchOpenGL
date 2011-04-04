//
//  CMaterial.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CMaterial.h"

#import "COpenGLAssetLibrary.h"

@implementation CMaterial

@synthesize name;
@synthesize ambientColor;
@synthesize diffuseColor;
@synthesize specularColor;
@synthesize shininess;
@synthesize alpha;
@synthesize texture;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        ambientColor = (Color4f){ 0.5, 0.5, 0.5, 1.0 };
        diffuseColor = (Color4f){ 0.5, 0.5, 0.5, 1.0 };
        specularColor = (Color4f){ 0.5, 0.5, 0.5, 1.0 };
        shininess = 1.0;
        alpha = 1.0;
		}
	return(self);
	}

- (void)dealloc
    {
    [name release];
    name = NULL;
    
    [texture release];
    texture = NULL;
    //
    [super dealloc];
    }

- (NSString *)description
    {
    return([NSString stringWithFormat:@"%@ (%@)", [super description], self.name]);
    }

@end
