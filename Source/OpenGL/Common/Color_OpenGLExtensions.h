//
//  UIColor_OpenGLExtensions.h
//  SketchTest
//
//  Created by Jonathan Wight on 02/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "OpenGLTypes.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
@interface UIColor (UIColor_OpenGLExtensions)
#elif TARGET_OS_MAC
@interface NSColor (NSColor_OpenGLExtensions)
#endif

@property (readonly, nonatomic, assign) Color4f color4f;
@property (readonly, nonatomic, assign) Color4ub color4ub;

@end
