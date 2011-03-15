//
//  CLibrary.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/14/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CLibrary.h"

#import "CVertexBuffer.h"

@interface CLibrary ()
@property (readwrite, nonatomic, retain) NSCache *cache;
@end

@implementation CLibrary

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

- (CVertexBuffer *)vertexBufferForName:(NSString *)inName
    {
    CVertexBuffer *theObject = [self.cache objectForKey:inName];
    if (theObject == NULL)
        {
        NSURL *theVBOURL = [[NSBundle mainBundle] URLForResource:[inName stringByDeletingPathExtension] withExtension:[inName pathExtension]];
        NSData *theVBOData = [NSData dataWithContentsOfURL:theVBOURL options:0 error:NULL];
        theObject = [[[CVertexBuffer alloc] initWithTarget:GL_ELEMENT_ARRAY_BUFFER usage:GL_STATIC_DRAW data:theVBOData] autorelease];
        NSLog(@"LOADED: %@", theObject);
        
        [self.cache setObject:theObject forKey:inName cost:theVBOData.length];
        }
    
    return(theObject);
    }

@end
