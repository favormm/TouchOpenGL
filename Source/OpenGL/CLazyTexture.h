//
//  CLazyTexture.h
//  ModelViewer_OSX
//
//  Created by Jonathan Wight on 04/04/11.
//  Copyright 2011 Inkling. All rights reserved.
//

#import "CTexture.h"


@interface CLazyTexture : CTexture {
    
}

@property (readonly, nonatomic, assign) CGImageRef image;

- (id)initWIthImage:(CGImageRef)inImage;

@end
