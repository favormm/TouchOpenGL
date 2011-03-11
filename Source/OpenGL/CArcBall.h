//
//  CArcBall.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/09/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Quaternion.h"
#import "Matrix.h"

@interface CArcBall : NSObject {
    
}

@property (readonly, nonatomic, assign) Quaternion rotation;
@property (readonly, nonatomic, assign) Matrix4 rotationMatrix;

- (void)start:(CGPoint)inPoint;
- (void)dragTo:(CGPoint)inPoint;

@end
