//
//  CSceneGraphRenderer.m
//  Racing Gene
//
//  Created by Jonathan Wight on 01/31/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CSceneGraphRenderer.h"

#import "CScene.h"
#import "CSceneStyle.h"

@interface CSceneGraphRenderer ()
@property (readwrite, nonatomic, retain) NSMutableArray *styleStack;
@property (readwrite, nonatomic, retain) NSMutableArray *transformStack;

@end

@implementation CSceneGraphRenderer

@synthesize sceneGraph;

@synthesize styleStack;
@synthesize transformStack;

- (id)init
    {
    if ((self = [super init]) != NULL)
        {
        }
    return(self);
    }

- (id)initWithSceneGraph:(CScene *)inSceneGraph
	{
	if ((self = [self init]) != NULL)
		{
        sceneGraph = [inSceneGraph retain];
		}
	return(self);
	}

- (void)dealloc
    {
    [sceneGraph release];
    sceneGraph = NULL;
    //
    [super dealloc];
    }

#pragma mark -

- (void)prerender
    {
    [super prerender];
    //
    self.styleStack = [NSMutableArray array];
    self.transformStack = [NSMutableArray array];
    }

- (void)render:(Matrix4)inTransform
    {    
    [super render:inTransform];
    
    [self pushTransform:inTransform];
    
    [self.sceneGraph prerender:self];
    [self.sceneGraph render:self];
    [self.sceneGraph postrender:self];

    [self popTransform:inTransform];

    }

#pragma mark -

- (CSceneStyle *)mergedStyle
    {
    CSceneStyle *theMergedStyle = [[[CSceneStyle alloc] init] autorelease];
    for (CSceneStyle *theStyle in self.styleStack)
        {
        if (theStyle.mask & SceneStyleMask_ColorFlag)
            {
            theMergedStyle.mask |= SceneStyleMask_ColorFlag;
            theMergedStyle.color = theStyle.color;
            }
        if (theStyle.mask & SceneStyleMask_LineWidthFlag)
            {
            theMergedStyle.mask |= SceneStyleMask_LineWidthFlag;
            theMergedStyle.lineWidth = theStyle.lineWidth;
            }
        if (theStyle.mask & SceneStyleMask_TextureFlag)
            {
            theMergedStyle.mask |= SceneStyleMask_TextureFlag;
            theMergedStyle.texture = theStyle.texture;
            }
        if (theStyle.mask & SceneStyleMask_ProgramFlag)
            {
            theMergedStyle.mask |= SceneStyleMask_ProgramFlag;
            theMergedStyle.program = theStyle.program;
            }
        }
    return(theMergedStyle);
    }

- (Matrix4)transform
    {
    Matrix4 theTransform = Matrix4Identity;
    for (NSValue *theValue in self.transformStack)
        {
        Matrix4 theRHS;
        [theValue getValue:&theRHS];
        theTransform = Matrix4Concat(theTransform, theRHS);
        }
    return(theTransform);
    }

#pragma mark -

- (void)pushStyle:(CSceneStyle *)inStyle
    {
    [self.styleStack addObject:inStyle];
    }
    
- (void)popStyle:(CSceneStyle *)inStyle
    {
    [self.styleStack removeLastObject];
    }

#pragma mark -

- (void)pushTransform:(Matrix4)inTransform
    {
    [self.transformStack addObject:[NSValue valueWithBytes:&inTransform objCType:@encode(Matrix4)]];
    }
    
- (void)popTransform:(Matrix4)inTransform
    {
    [self.transformStack removeLastObject];
    }

@end
