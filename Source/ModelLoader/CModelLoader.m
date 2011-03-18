//
//  CModelLoader.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/09/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CModelLoader.h"

#import "CScene.h"
#import "CSceneNode.h"
#import "CSceneGeometry.h"
#import "CSceneStyle.h"
#import "CSceneGeometryBrush.h"

#import "CVertexBuffer.h"
#import "CVertexBufferReference.h"
#import "UIColor_OpenGLExtensions.h"
#import "OpenGLTypes.h"

@interface CModelLoader ()
@property (readwrite, nonatomic, retain) NSDictionary *library;

- (CSceneNode *)nodeForDictionary:(NSDictionary *)inDictionary error:(NSError **)outError;
- (CSceneGeometry *)geometryForDictionary:(NSDictionary *)inDictionary error:(NSError **)outError;
@end

#pragma mark -

@implementation CModelLoader

@synthesize library;

- (CScene *)load:(NSURL *)inURL error:(NSError **)outError
    {
    NSDictionary *theDictionary = [NSDictionary dictionaryWithContentsOfURL:inURL];
    
    NSDictionary *theRootDictionary = [theDictionary objectForKey:@"root"];
    self.library = [theDictionary objectForKey:@"library"];
    CSceneNode *theNode = [self nodeForDictionary:theRootDictionary error:NULL];
    // TODO -- make sure it's a scene node
    
    [theNode dump];

    theNode.transform = Matrix4MakeScale(0.0005, 0.0005, 0.0005);

    
    return((CScene *)theNode);
    }

- (CSceneNode *)nodeForDictionary:(NSDictionary *)inDictionary error:(NSError **)outError
    {
    CSceneNode *theNode = NULL;
    if ([[inDictionary objectForKey:@"type"] isEqualToString:@"Scene"])
        {
        theNode = [[[CScene alloc] init] autorelease];
        }
    else if ([[inDictionary objectForKey:@"type"] isEqualToString:@"Node"])
        {
        theNode = [[[CSceneNode alloc] init] autorelease];
        }
    else if ([[inDictionary objectForKey:@"type"] isEqualToString:@"Instance"])
        {
        NSURL *theURL = [NSURL URLWithString:[inDictionary objectForKey:@"url"]];
        NSDictionary *theDictionary = [self.library objectForKey:theURL.fragment];
        theNode = [self nodeForDictionary:theDictionary error:NULL];
        }
    else if ([[inDictionary objectForKey:@"type"] isEqualToString:@"Geometry"])
        {
        theNode = [self geometryForDictionary:inDictionary error:NULL];
        }

    if ([inDictionary objectForKey:@"id"])
        {
        theNode.name = [inDictionary objectForKey:@"id"];
        }

    for (NSDictionary *theChildDictionary in [inDictionary objectForKey:@"children"])
        {
        CSceneNode *theChildNode = [self nodeForDictionary:theChildDictionary error:NULL];
        if (theChildNode)
            {
            [theNode addSubnode:theChildNode];
            }
        }
    
    return(theNode);
    }

- (CSceneGeometry *)geometryForDictionary:(NSDictionary *)inDictionary error:(NSError **)outError
    {
    CSceneGeometry *theGeometryNode = [[[CSceneGeometry alloc] init] autorelease];
    NSDictionary *theTrianglesDictionary = [[[inDictionary objectForKey:@"children"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type == 'triangles'"]] lastObject];
    
    
    NSString *theVBOName = [theTrianglesDictionary objectForKey:@"indices"];
    NSURL *theVBOURL = [[NSBundle mainBundle] URLForResource:[theVBOName stringByDeletingPathExtension] withExtension:[theVBOName pathExtension]];
    NSData *theVBOData = [NSData dataWithContentsOfURL:theVBOURL options:0 error:NULL];
    CVertexBuffer *theVertexBuffer = [[[CVertexBuffer alloc] initWithTarget:GL_ELEMENT_ARRAY_BUFFER usage:GL_STATIC_DRAW data:theVBOData] autorelease];
    CVertexBufferReference *theVertexBufferReference = [[[CVertexBufferReference alloc] initWithVertexBuffer:theVertexBuffer cellEncoding:@encode(GLushort) normalized:NO] autorelease];
    theGeometryNode.indicesBufferReference = theVertexBufferReference;

    theVBOName = [theTrianglesDictionary objectForKey:@"positions"];
    theVBOURL = [[NSBundle mainBundle] URLForResource:[theVBOName stringByDeletingPathExtension] withExtension:[theVBOName pathExtension]];
    theVBOData = [NSData dataWithContentsOfURL:theVBOURL options:0 error:NULL];
    theVertexBuffer = [[[CVertexBuffer alloc] initWithTarget:GL_ARRAY_BUFFER usage:GL_STATIC_DRAW data:theVBOData] autorelease];
    theVertexBufferReference = [[[CVertexBufferReference alloc] initWithVertexBuffer:theVertexBuffer cellEncoding:@encode(Vector3) normalized:NO] autorelease];
    theGeometryNode.coordinatesBufferReference = theVertexBufferReference;
    
    theVBOName = [theTrianglesDictionary objectForKey:@"normals"];
    theVBOURL = [[NSBundle mainBundle] URLForResource:[theVBOName stringByDeletingPathExtension] withExtension:[theVBOName pathExtension]];
    theVBOData = [NSData dataWithContentsOfURL:theVBOURL options:0 error:NULL];
    theVertexBuffer = [[[CVertexBuffer alloc] initWithTarget:GL_ARRAY_BUFFER usage:GL_STATIC_DRAW data:theVBOData] autorelease];
    theVertexBufferReference = [[[CVertexBufferReference alloc] initWithVertexBuffer:theVertexBuffer cellEncoding:@encode(Vector3) normalized:NO] autorelease];
    theGeometryNode.normalsBufferReference = theVertexBufferReference;
    
    
    CSceneStyle *theStyle = [[[CSceneStyle alloc] init] autorelease];
    theStyle.mask = SceneStyleMask_ProgramFlag | SceneStyleMask_ColorFlag;
    theStyle.program = [[[CProgram alloc] initWithName:@"Flat"] autorelease];
    theStyle.color = [UIColor redColor].color4f;
    theGeometryNode.style = theStyle;


//    theGeometryNode.transform = Matrix4MakeScale(0.0005, 0.0005, 0.0005);

    
    CSceneGeometryBrush *theBrush = [[[CSceneGeometryBrush alloc] init] autorelease];
    theBrush.type = GL_TRIANGLES;
    theBrush.geometry = theGeometryNode;
    [theGeometryNode addSubnode:theBrush];

    
    return(theGeometryNode);
    }

@end
