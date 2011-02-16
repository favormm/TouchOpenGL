//
//  SketchTestViewController.m
//  SketchTest
//
//  Created by Jonathan Wight on 02/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "SketchTestViewController.h"

#import "CSketchView.h"
#import "CSketchRenderer.h"

@implementation SketchTestViewController

- (CSketchView *)sketchView
    {
    return((CSketchView *)self.view);
    }

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
    {
    return(YES);
    }

@end
