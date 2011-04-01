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
@synthesize texture;

//    MaterialParameters u_FrontMaterial = MaterialParameters(
//        vec4(0.2, 0.25, 0.2, 1), //ambient 
//        vec4(1, 0, 0, 1), // diffuse
//        vec4(0, 0, 0, 1), // specular
//        1.0 // shiness


- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        ambientColor = (Color4f){ 0.5, 0.5, 0.5, 1.0 };
        diffuseColor = (Color4f){ 0.5, 0.5, 0.5, 1.0 };
        specularColor = (Color4f){ 0.5, 0.5, 0.5, 1.0 };
        shininess = 1.0;
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


#pragma mark -

- (id)initWithPropertyListRepresentation:(id)inRepresentation error:(NSError **)outError;
	{
    #pragma unused (outError)
    
	if ((self = [self init]) != NULL)
		{
        name = [[(NSDictionary *)inRepresentation objectForKey:@"name"] retain];
        
        id theObject = NULL;
        
        theObject = [(NSDictionary *)inRepresentation objectForKey:@"ambientColor"];
        if (theObject != NULL)
            {
            ambientColor = Color4fFromPropertyListRepresentation(theObject);
            }
        
        theObject = [(NSDictionary *)inRepresentation objectForKey:@"diffuseColor"];
        if (theObject != NULL)
            {
            diffuseColor = Color4fFromPropertyListRepresentation(theObject);
            }
        
        theObject = [(NSDictionary *)inRepresentation objectForKey:@"specularColor"];
        if (theObject != NULL)
            {
            specularColor = Color4fFromPropertyListRepresentation(theObject);
            }
            
        theObject = [(NSDictionary *)inRepresentation objectForKey:@"texture"];
        if (theObject != NULL)
            {
            texture = [[[COpenGLAssetLibrary sharedInstance] textureForName:theObject error:outError] retain];
            }
        
		}
	return(self);
	}


@end
