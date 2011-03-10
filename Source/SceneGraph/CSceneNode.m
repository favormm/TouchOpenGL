//
//  CSceneGraphNode.m
//  Racing Genes
//
//  Created by Jonathan Wight on 09/23/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CSceneNode.h"

#import "CSceneNode.h"
#import "CSceneGraphRenderer.h"

@interface CSceneNode ()
@property (readwrite, nonatomic, retain) NSMutableArray *mutableSubnodes;
@end

@implementation CSceneNode

@synthesize supernode;
@synthesize transform;
@synthesize style;
@synthesize subnodes;

@synthesize mutableSubnodes;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        transform = Matrix4Identity;
		}
	return(self);
	}

- (void)dealloc
    {
    [style release];
    style = NULL;
    [subnodes release];
    subnodes = NULL;
    //
    [super dealloc];
    }
    
- (NSArray *)subnodes
    {
    return(self.mutableSubnodes);
    }
    
- (void)addSubnode:(CSceneNode *)inSubnode
    {
    if (self.mutableSubnodes == NULL)
        {
        self.mutableSubnodes = [NSMutableArray array];
        }
    [self.mutableSubnodes addObject:inSubnode];
    }

- (void)prerender:(CSceneGraphRenderer *)inRenderer
    {
    if (self.style != NULL)
        {
        [inRenderer.styleStack addObject:self.style];
        }
    }

- (void)render:(CSceneGraphRenderer *)inRenderer
    {
    for (CSceneNode *theNode in self.subnodes)
        {
        [theNode prerender:inRenderer];
        [theNode render:inRenderer];
        [theNode postrender:inRenderer];
        }
    }

- (void)postrender:(CSceneGraphRenderer *)inRenderer;
    {
    if (self.style != NULL && self.style == [inRenderer.styleStack lastObject])
        {
        [inRenderer.styleStack removeLastObject];
        }
    }
    
- (void)dump
    {
    __block void (^theBlock)(CSceneNode *, NSInteger) = NULL;
    static char theBuffer[256];
    memset(theBuffer, ' ', sizeof(theBuffer));
    theBlock = ^(CSceneNode *inNode, NSInteger inDepth){
        fprintf(stdout, "%.*s%s\n", inDepth * 2, theBuffer, [[inNode description] UTF8String]);
        
        for (CSceneNode *theNode in inNode.subnodes)
            {
            theBlock(theNode, inDepth + 1);
            }
        };
    
    theBlock(self, 0);
    }



@end
