//
//  SketchTestViewController.m
//  SketchTest
//
//  Created by Jonathan Wight on 02/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CTestViewController.h"

#import "CRendererView.h"
#import "CTestRenderer.h"

@implementation CTestViewController

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
    self.view = [[[CRendererView alloc] initWithFrame:CGRectZero] autorelease];
    }
    
- (void)viewDidLoad
    {
    self.rendererView.renderer = [[[CTestRenderer alloc] init] autorelease];
    }

@end
