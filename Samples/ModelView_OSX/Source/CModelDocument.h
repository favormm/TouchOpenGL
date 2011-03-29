//
//  PopTipDocument.h
//  PopTipEditor
//
//  Created by Aaron Golden on 3/21/11.
//  Copyright 2011 Inkling. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class COBJRenderer;
@class CRendererView;

@interface CModelDocument : NSDocument {
}

@property (nonatomic, retain) COBJRenderer *renderer;
@property (nonatomic, retain) IBOutlet CRendererView *mainView;

@property (nonatomic, assign) GLfloat roll;
@property (nonatomic, assign) GLfloat pitch;
@property (nonatomic, assign) GLfloat yaw;
@property (nonatomic, assign) GLfloat scale;

@end
