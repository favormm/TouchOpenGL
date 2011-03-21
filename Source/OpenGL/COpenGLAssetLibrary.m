//
//  COpenGLAssetLibrary.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/14/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "COpenGLAssetLibrary.h"

#import "CVertexBuffer.h"

@interface COpenGLAssetLibrary ()
@property (readwrite, nonatomic, retain) NSCache *cache;
@end

@implementation COpenGLAssetLibrary

@synthesize cache;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        cache = [[NSCache alloc] init];
		}
	return(self);
	}

- (void)dealloc
    {
    [cache release];
    cache = NULL;
    //
    [super dealloc];
    }

- (CVertexBuffer *)vertexBufferForName:(NSString *)inName target:(GLenum)inTarget usage:(GLenum)inUsage
    {
    CVertexBuffer *theObject = [self.cache objectForKey:inName];
    if (theObject == NULL)
        {
        NSURL *theVBOURL = [[NSBundle mainBundle] URLForResource:[inName stringByDeletingPathExtension] withExtension:[inName pathExtension]];
        NSData *theVBOData = [NSData dataWithContentsOfURL:theVBOURL options:0 error:NULL];
        theObject = [[[CVertexBuffer alloc] initWithTarget:inTarget usage:inUsage data:theVBOData] autorelease];
        
        [self.cache setObject:theObject forKey:inName cost:theVBOData.length];
        }
    
    return(theObject);
    }

- (CTexture *)textureForName:(NSString *)inName error:(NSError **)outError
    {
    return(NULL);
    }

@end
