//
//  CSceneGeometry_ConvenienceExtensions.m
//  Racing Gene
//
//  Created by Jonathan Wight on 01/31/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CSceneGeometry_ConvenienceExtensions.h"

#import "CProgram.h"
#import "CProgram_ConvenienceExtensions.h"
#import "CVertexBuffer.h"
#import "CVertexBuffer_FactoryExtensions.h"
#import "CVertexBufferReference.h"
#import "CSceneStyle.h"
#import "CSceneGeometryBrush.h"

@implementation CSceneGeometry (CSceneGeometry_ConvenienceExtensions)

+ (CSceneGeometry *)flatGeometryNodeWithCoordinatesBuffer:(CVertexBuffer *)inVertexBuffer;
    {
    CSceneGeometry *theGeometry = [[[CSceneGeometry alloc] init] autorelease];
    theGeometry.coordinatesBufferReference = [[[CVertexBufferReference alloc] initWithVertexBuffer:inVertexBuffer cellEncoding:@encode(Vector2) normalized:GL_FALSE] autorelease];
    theGeometry.vertexBuffers = [NSSet setWithObjects:inVertexBuffer, NULL];

    CSceneStyle *theStyle = [[[CSceneStyle alloc] init] autorelease];
    theStyle.mask = SceneStyleMask_ProgramFlag;
    theGeometry.style = theStyle;

    CProgram *theFlatProgram = [[[CProgram alloc] initWithFilename:@"Flat" attributeNames:[NSArray arrayWithObjects:@"vertex", @"color", @"texture", NULL] uniformNames:NULL] autorelease];
    theStyle.program = theFlatProgram;
    
    
    CSceneGeometryBrush *theBrush = [[[CSceneGeometryBrush alloc] init] autorelease];
    theBrush.type = GL_LINE_STRIP;
    theBrush.geometry = theGeometry;
    
    [theGeometry addSubnode:theBrush];
    
    return(theGeometry);
    }
    
@end
