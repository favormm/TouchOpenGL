//
//  CSceneGeometryBrush.m
//  Racing Gene
//
//  Created by Jonathan Wight on 02/05/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CSceneGeometryBrush.h"

#import "CSceneStyle.h"
#import "CSceneGraphRenderer.h"
#import "CVertexBufferReference.h"
#import "CVertexBuffer.h"

@implementation CSceneGeometryBrush

@synthesize type;
@synthesize geometry;

- (void)render:(CSceneGraphRenderer *)inRenderer;
    {
    CSceneStyle *theStyle = [inRenderer mergedStyle];
    CSceneGeometry *theGeometry = self.geometry;

    // Use shader program
    CProgram *theProgram = theStyle.program;

    // Validate program before drawing. This is a good check, but only really necessary in a debug build. DEBUG macro must be defined in your debug configurations if that's not already the case.
#if defined(DEBUG)
    NSError *theError = NULL;
    if ([theProgram validate:&theError] == NO)
        {
        NSLog(@"Failed to validate program: %@", theError);
        return;
        }
#endif
    AssertOpenGLNoError_();

    if (theStyle != NULL)
        {
        Color4f theStrokeColor = theStyle.color;
        
        GLuint theColorUniformIndex = [theProgram uniformIndexForName:@"u_color"];
        glUniform4fv(theColorUniformIndex, 1, &theStrokeColor.r);
        }

    if (theStyle.mask & SceneStyleMask_LineWidthFlag)
        {
        glLineWidth(theStyle.lineWidth);
        }
    AssertOpenGLNoError_();
    
//#if DEBUG == 1
//    NSLog(@"> %d %d", theGeometry.indicesBufferReference.cellCount, theGeometry.coordinatesBufferReference.cellCount);
//#endif

    if (theGeometry.indicesBufferReference)
        {
        CVertexBufferReference *theReference = theGeometry.indicesBufferReference;
        //
        NSAssert(theReference.cellCount != 0, @"Incorrect number of cells");
        AssertOpenGLNoError_();
        //
        glDrawElements(self.type, theReference.cellCount, theReference.type, NULL);
        }
    else
        {
        glDrawArrays(self.type, 0, theGeometry.coordinatesBufferReference.cellCount);
        }
        
    AssertOpenGLNoError_();
    }


@end
