//
//  CBlockRenderer.h
//  SketchTest
//
//  Created by Jonathan Wight on 02/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CRenderer.h"


@interface CBlockRenderer : CRenderer {
    
}

@property (readwrite, nonatomic, copy) void (^prepareBlock)(void);
@property (readwrite, nonatomic, copy) void (^prerenderBlock)(void);
@property (readwrite, nonatomic, copy) void (^renderBlock)(void);
@property (readwrite, nonatomic, copy) void (^postrenderBlock)(void);

@end
