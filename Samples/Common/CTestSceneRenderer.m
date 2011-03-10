//
//  CTestSceneRenderer.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/09/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CTestSceneRenderer.h"

#import "CScene.h"
#import "CSceneGeometry.h"
#import "CSceneStyle.h"
#import "CProgram_ConvenienceExtensions.h"
#import "CVertexBufferReference.h"
#import "OpenGLTypes.h"
#import "CVertexBuffer.h"
#import "CSceneGeometryBrush.h"
#import "CVertexBuffer_FactoryExtensions.h"
#import "UIColor_OpenGLExtensions.h"

@implementation CTestSceneRenderer

- (id)init
    {
    if ((self = [super init]) != NULL)
        {
        CScene *theScene = [[[CScene alloc] init] autorelease];
                
        CVertexBuffer *theCoordinatesVertexBuffer = [CVertexBuffer vertexBufferWithRect:(CGRect){ -0.5, -0.5, 1, 1 }];
        CVertexBuffer *theColorsVertexBuffer = [CVertexBuffer vertexBufferWithColors:[NSArray arrayWithObjects:[UIColor redColor], [UIColor redColor], [UIColor redColor], [UIColor redColor], NULL]];

        CSceneGeometry *theGeometry = [[[CSceneGeometry alloc] init] autorelease];
        theGeometry.coordinatesBufferReference = [[[CVertexBufferReference alloc] initWithVertexBuffer:theCoordinatesVertexBuffer cellEncoding:@encode(Vector2) normalized:GL_FALSE stride:0] autorelease];
        theGeometry.colorsBufferReference = [[[CVertexBufferReference alloc] initWithVertexBuffer:theColorsVertexBuffer cellEncoding:@encode(Color4f) normalized:GL_TRUE stride:0] autorelease];
        theGeometry.vertexBuffers = [NSSet setWithObjects:theCoordinatesVertexBuffer, theColorsVertexBuffer, NULL];

        CSceneStyle *theStyle = [[[CSceneStyle alloc] init] autorelease];
        theStyle.mask = SceneStyleMask_ProgramFlag | SceneStyleMask_ColorFlag;
        theGeometry.style = theStyle;

        CProgram *theFlatProgram = [[[CProgram alloc] initWithFilename:@"Flat" attributeNames:[NSArray arrayWithObjects:@"vertex", @"color", @"texture", NULL] uniformNames:NULL] autorelease];
        theStyle.program = theFlatProgram;
        
        theStyle.color = [[UIColor redColor] color4f];
        
        CSceneGeometryBrush *theBrush = [[[CSceneGeometryBrush alloc] init] autorelease];
        theBrush.type = GL_TRIANGLE_STRIP;
        theBrush.geometry = theGeometry;
        
        [theGeometry addSubnode:theBrush];
        
        [theScene addSubnode:theGeometry];

        [theScene dump];
        
        self.sceneGraph = theScene;
        }
    return(self);
    }


@end
