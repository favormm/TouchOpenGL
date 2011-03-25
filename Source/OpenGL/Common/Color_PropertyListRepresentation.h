//
//  UIColor_PropertyListRepresentation.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/21/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CPropertyListRepresentation.h"

#if TARGET_OS_IPHONE
@interface UIColor (UIColor_PropertyListRepresentation) <CPropertyListRepresentation>
#elif TARGET_OS_MAC
@interface NSColor (NSColor_PropertyListRepresentation) <CPropertyListRepresentation>
#endif

- (id)initWithPropertyListRepresentation:(id)inRepresentation error:(NSError **)outError;

@end
