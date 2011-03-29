//
//  PopTipDocument.m
//  PopTipEditor
//
//  Created by Aaron Golden on 3/21/11.
//  Copyright 2011 Inkling. All rights reserved.
//

#import "CModelDocument.h"

#import "CRendererView.h"
#import "CRendererOpenGLLayer.h"
#import "COBJRenderer.h"
#import "Matrix.h"

@implementation CModelDocument

@synthesize renderer;
@synthesize mainView;
@synthesize roll;

- (id)init
    {
    if ((self = [super init]) != NULL)
        {
        renderer = [[COBJRenderer alloc] init];
        }
    return self;
    }

- (void)dealloc
    {
    [mainView release];
    [renderer release];
    //
    [super dealloc];
    }

- (NSString *)windowNibName
    {
    return @"PopTipDocument";
    }

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
    {
    [super windowControllerDidLoadNib:aController];
    //
    [self.mainView setWantsLayer:YES];
    self.mainView.rendererLayer.renderer = self.renderer;
    }

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
    {
    if (outError)
        {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
        }
    return nil;
    }

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
    {
    if (outError)
        {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
        }
    return(YES);
    }


@end
