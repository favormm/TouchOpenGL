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

@interface CModelViewController () <UIActionSheetDelegate>

@end

@implementation CModelViewController

- (CInteractiveRendererView *)rendererView
    {
    return((CInteractiveRendererView *)self.view);
    }

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
    {
    #pragma unused (interfaceOrientation)
    return(YES);
    }
    
- (void)viewDidLoad
    {
    [super viewDidLoad];

    COBJRenderer *theRenderer = [[[COBJRenderer alloc] init] autorelease];
    
    self.rendererView.renderer = theRenderer;
    }

- (IBAction)click:(id)inSender;
    {
    
    UIActionSheet *theActionSheet = [[[UIActionSheet alloc] initWithTitle:NULL delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:NULL otherButtonTitles:@"Front", @"Back", @"Left", @"Right", @"Top", @"Bottom", NULL] autorelease];
    [theActionSheet showFromRect:[self.view convertRect:[inSender frame] toView:self.view] inView:self.view animated:YES];
    }

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
    {
    NSLog(@"TEST: %d", buttonIndex);
    if (buttonIndex == 0)
        {
        self.rendererView.transform = Matrix4Identity;
        
        self.rendererView.motionRotation = QuaternionIdentity;
        self.rendererView.gestureRotation = QuaternionIdentity;
        self.rendererView.savedRotation = QuaternionIdentity;
        }
    
    
    
    }

@end
