//
//  Color_OpenGLExtensions.h
//  PopTipEditor
//
//  Created by Aaron Golden on 3/21/11,
//  based on UIColor_OpenGLExtensions
//  created by Jonathan Wight on 02/15/11.
//
//  Copyright 2011 Inkling. All rights reserved.
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
