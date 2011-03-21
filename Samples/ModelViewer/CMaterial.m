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
        
        NSString *theString = NULL;
        UIColor *theColor = NULL;
        
        theString = [(NSDictionary *)inRepresentation objectForKey:@"ambientColor"];
        theColor = [[[UIColor alloc] initWithPropertyListRepresentation:theString error:outError] autorelease];
        ambientColor = theColor.color4f;
        
        theString = [(NSDictionary *)inRepresentation objectForKey:@"diffuseColor"];
        theColor = [[[UIColor alloc] initWithPropertyListRepresentation:theString error:outError] autorelease];
        diffuseColor = theColor.color4f;
        
        theString = [(NSDictionary *)inRepresentation objectForKey:@"specularColor"];
        theColor = [[[UIColor alloc] initWithPropertyListRepresentation:theString error:outError] autorelease];
        specularColor = theColor.color4f;
            
        theString = [(NSDictionary *)inRepresentation objectForKey:@"texture"];
        if (theString.length > 0)
            {
            texture = [[[COpenGLAssetLibrary sharedInstance] textureForName:theString error:outError] retain];
            }
        
		}
	return(self);
	}


@end
