//
//  SketchTestViewController.m
//  SketchTest
//
//  Created by Jonathan Wight on 02/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CModelViewController.h"

#import "CInteractiveRendererView.h"
//#import "CModelLoader.h"
#import "COBJRenderer.h"

@interface CModelViewController ()

@end

@implementation CModelViewController

- (CRendererView *)rendererView
    {
    return((CRendererView *)self.view);
    }

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
    {
    return(YES);
    }
    
- (void)loadView
    {
    self.view = [[[CInteractiveRendererView alloc] initWithFrame:CGRectZero] autorelease];

    CRenderer *theRenderer = NULL;
    if (0)
        {
//        CModelLoader *theLoader = [[[CModelLoader alloc] init] autorelease];
//        NSURL *theModelURL = [[NSBundle mainBundle] URLForResource:@"Cube" withExtension:@"plist"];
//        NSError *theError = NULL;
//        CScene *theScene = [theLoader load:theModelURL error:&theError];
//        CSceneGraphRenderer *theSceneRenderer = [[[CSceneGraphRenderer alloc] init] autorelease];
//        theSceneRenderer.sceneGraph = theScene;
//        theRenderer = theSceneRenderer;
        }
    else if (1)
        {
        theRenderer = [[[COBJRenderer alloc] init] autorelease];
        }
//    else if (1)
//        {
//        theRenderer = [[[CTestSceneRenderer alloc] init] autorelease];
//        }
    
    self.rendererView.renderer = theRenderer;
    }

@end
