//
//  NSColor_OpenGLExtensions.h
//  Racing Gene
//
//  Created by Jonathan Wight on 02/05/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <AppKit/AppKit.h>

#import "OpenGLTypes.h"

@interface NSColor (NSColor_OpenGLExtensions)

- (Color4f)color4f;
- (Color4ub)color4ub;

@end
