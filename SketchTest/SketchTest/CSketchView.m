//
//  CSketchView.m
//  SketchTest
//
//  Created by Jonathan Wight on 02/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CSketchView.h"

#import "CSketchCanvas.h"
#import "CSketchRenderer.h"
#import "CImageRenderer.h"

@interface CSketchView ()
@property (readwrite, nonatomic, retain) CSketchCanvas *canvas;
@end

#pragma mark -

@implementation CSketchView

@synthesize canvas;

- (id)initWithCoder:(NSCoder *)inCoder
	{
	if ((self = [super initWithCoder:inCoder]) != NULL)
		{
        [EAGLContext setCurrentContext:self.context];
        
        NSLog(@"> %@", self.context);

        canvas = [[CSketchCanvas alloc] init];

        CSketchRenderer *theRenderer = [[[CSketchRenderer alloc] init] autorelease];
        theRenderer.texture = canvas.imageRenderer.texture;
        
        
        self.renderer = theRenderer;
		}
	return(self);
	}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
    {
    }
    
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
    {
    UITouch *theTouch = [touches anyObject];

    [self.canvas drawAtPoint:[theTouch locationInView:self]];
    }

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
    {
    }
    
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
    {
    }

@end
