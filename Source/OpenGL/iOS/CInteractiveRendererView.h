//
//  CInteractiveRendererView.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/09/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CRendererView.h"

#import "Quaternion.h"

@interface CInteractiveRendererView : CRendererView {
    
}

@property (readwrite, nonatomic, assign) Quaternion motionRotation;
@property (readwrite, nonatomic, assign) Quaternion gestureRotation;
@property (readwrite, nonatomic, assign) Quaternion savedRotation;
@property (readwrite, nonatomic, assign) CGFloat scale;

@end
