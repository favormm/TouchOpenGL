//
//  COpenGLAssetLibrary.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/14/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "COpenGLAssetLibrary.h"

#import <objc/runtime.h>

#import "CVertexBuffer.h"
#import "CImageTextureLoader.h"
#import "CProgram.h"

@interface COpenGLAssetLibrary ()
@property (readwrite, nonatomic, retain) NSCache *vertexBufferCache;
@property (readwrite, nonatomic, retain) NSCache *textureCache;
@property (readwrite, nonatomic, retain) NSCache *programCache;
@end

@implementation COpenGLAssetLibrary

@synthesize vertexBufferCache;
@synthesize textureCache;
@synthesize programCache;

+ (COpenGLAssetLibrary *)sharedInstance;
    {
    // TODO at some point this will be a singleton - maybe - but not today.
    // (We really need one per OGL context anyway singleton = bad here)
    return([[[self alloc] init] autorelease]);
    }

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        vertexBufferCache = [[NSCache alloc] init];
        textureCache = [[NSCache alloc] init];
        programCache = [[NSCache alloc] init];
		}
	return(self);
	}

- (void)dealloc
    {
    [vertexBufferCache release];
    vertexBufferCache = NULL;

    [textureCache release];
    textureCache = NULL;

    [programCache release];
    programCache = NULL;
    //
    [super dealloc];
    }

- (CVertexBuffer *)vertexBufferForName:(NSString *)inName target:(GLenum)inTarget usage:(GLenum)inUsage
    {
    CVertexBuffer *theObject = [self.vertexBufferCache objectForKey:inName];
    if (theObject == NULL)
        {
        NSURL *theVBOURL = [[NSBundle mainBundle] URLForResource:[inName stringByDeletingPathExtension] withExtension:[inName pathExtension]];
        NSData *theVBOData = [NSData dataWithContentsOfURL:theVBOURL options:0 error:NULL];
        theObject = [[[CVertexBuffer alloc] initWithTarget:inTarget usage:inUsage data:theVBOData] autorelease];
        
        [self.vertexBufferCache setObject:theObject forKey:inName cost:theVBOData.length];
        }
    
    return(theObject);
    }

- (CTexture *)textureForName:(NSString *)inName error:(NSError **)outError
    {
    // TODO roll CImageTextureLoader code into this class perhaps?
    CImageTextureLoader *theLoader = [[[CImageTextureLoader alloc] init] autorelease];
    return([theLoader textureWithImageNamed:inName error:outError]);
    }

- (CProgram *)programForName:(NSString *)inName attributeNames:(NSArray *)inAttributeNames uniformNames:(NSArray *)inUniformNames error:(NSError **)outError;
    {
    #pragma ignored (outError)
    
    CProgram *theProgram = [self.programCache objectForKey:inName];
    if (theProgram == NULL)
        {
        theProgram = [[[CProgram alloc] initWithName:inName attributeNames:inAttributeNames uniformNames:inUniformNames] autorelease];
        [self.programCache setObject:theProgram forKey:inName];
        }
    return(theProgram);
    }

@end

#pragma mark -

@implementation EAGLContext (EAGLContext_LibraryExtensions)

- (COpenGLAssetLibrary *)library   
    {
    static void *theKey = "EAGLContext_LibraryExtensions_Library";
    COpenGLAssetLibrary *theLibrary = objc_getAssociatedObject(self, theKey);
    if (theLibrary == NULL)
        {
        NSLog(@"CREATING LIB");
        theLibrary = [[[COpenGLAssetLibrary alloc] init] autorelease];
        objc_setAssociatedObject(self, theKey, theLibrary, OBJC_ASSOCIATION_RETAIN);
        }
    return(theLibrary);    
    }

@end


