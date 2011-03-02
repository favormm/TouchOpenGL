//
//  CImageRenderer.h
//  SketchTest
//
//  Created by Jonathan Wight on 02/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CBlockRenderer.h"

@class CFrameBuffer;
@class CRenderBuffer;
@class CTexture;

@interface CImageRenderer : CBlockRenderer {
    
}

@property (readwrite, nonatomic, assign) SIntSize size;
@property (readwrite, nonatomic, retain) CFrameBuffer *frameBuffer;
@property (readwrite, nonatomic, retain) CRenderBuffer *depthBuffer;
@property (readwrite, nonatomic, retain) CTexture *texture;

- (id)initWithSize:(SIntSize)inSize;

- (void)render;

@end
