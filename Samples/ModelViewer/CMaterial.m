//
//  CMaterial.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CMaterial.h"

#import "UIColor_OpenGLExtensions.h"
#import "UIColor_PropertyListRepresentation.h"
#import "COpenGLAssetLibrary.h"

@implementation CMaterial

@synthesize name;
@synthesize ambientColor;
@synthesize diffuseColor;
@synthesize specularColor;
@synthesize texture;

- (void)dealloc
    {
    [name release];
    name = NULL;
    
    [texture release];
    texture = NULL;
    //
    [super dealloc];
    }

#pragma mark -

- (id)initWithPropertyListRepresentation:(id)inRepresentation error:(NSError **)outError;
	{
    #pragma unused (outError)
    
	if ((self = [self init]) != NULL)
		{
        name = [[(NSDictionary *)inRepresentation objectForKey:@"name"] retain];
        
        id theObject = NULL;
        UIColor *theColor = NULL;
        
        theObject = [(NSDictionary *)inRepresentation objectForKey:@"ambientColor"];
        if (theObject != NULL)
            {
            theColor = [[[UIColor alloc] initWithPropertyListRepresentation:theObject error:outError] autorelease];
            ambientColor = theColor.color4f;
            }
        
        theObject = [(NSDictionary *)inRepresentation objectForKey:@"diffuseColor"];
        if (theObject != NULL)
            {
            theColor = [[[UIColor alloc] initWithPropertyListRepresentation:theObject error:outError] autorelease];
            diffuseColor = theColor.color4f;
            }
        
        theObject = [(NSDictionary *)inRepresentation objectForKey:@"specularColor"];
        if (theObject != NULL)
            {
            theColor = [[[UIColor alloc] initWithPropertyListRepresentation:theObject error:outError] autorelease];
            specularColor = theColor.color4f;
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
