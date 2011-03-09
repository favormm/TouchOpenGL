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

@implementation CSceneGraphRenderer

@synthesize sceneGraph;
@synthesize transform;
@synthesize styleStack;

- (id)init
    {
    if ((self = [super init]) != NULL)
        {
        __block __typeof__(self) _self = self;
        self.renderBlock = ^(void) {
            [_self.sceneGraph prerender:_self];
            [_self.sceneGraph render:_self];
            [_self.sceneGraph postrender:_self];
            };
            
        transform = Matrix4Identity;
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

- (void)prerender
    {
    [super prerender];
    //
    self.styleStack = [NSMutableArray array];
    }

- (void)dealloc
    {
    [sceneGraph release];
    sceneGraph = NULL;
    //
    [super dealloc];
    }

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

@end
