//
//  CSketchRenderer.m
//  SketchTest
//
//  Created by Jonathan Wight on 02/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CSketchRenderer.h"

#import "OpenGLTypes.h"
#import "CProgram.h"
#import "CShader.h"
#import "CVertexBuffer.h"
#import "CVertexBuffer_FactoryExtensions.h"
#import "CImageTextureLoader.h"
#import "CTexture.h"


@interface CSketchRenderer ()
@property (readwrite, nonatomic, assign) BOOL setupDone;

- (void)setup;
@end

#pragma mark -

@implementation CSketchRenderer

@synthesize texture;

@synthesize setupDone;

- (id)init
    {
    if ((self = [super init]) != NULL)
        {
        }
    return(self);
    }
    
- (void)render:(Matrix4)inTransform
    {
    if (self.setupDone == NO)
        {
        [self setup];
        self.setupDone = YES;
        }
        
    [super render:inTransform];
    }

- (void)setup
    {
    NSArray *theShaders = [NSArray arrayWithObjects:   
        [[[CShader alloc] initWithName:@"SimpleTexture.fsh"] autorelease],
        [[[CShader alloc] initWithName:@"SimpleTexture.vsh"] autorelease],
        NULL];
    
    CProgram *theProgram = [[[CProgram alloc] initWithFiles:theShaders] autorelease];

    // Geometry Vertices
    CVertexBuffer *theVertices = [CVertexBuffer vertexBufferWithRect:(CGRect){ -1, -1, 2, 2 }];
    CVertexBuffer *theTextureVertexBuffer = [CVertexBuffer vertexBufferWithRect:(CGRect){ 0, 0, 1, 1 }];

    // Colors

    GLuint theVertexAttributeIndex = [theProgram attributeIndexForName:@"vertex"];
    GLuint theTextureAttributeIndex = [theProgram attributeIndexForName:@"texture"];
    GLuint theTransformUniformIndex = [theProgram uniformIndexForName:@"transform"];
    
    
    self.renderBlock = ^(Matrix4 inTransform) {

        AssertOpenGLNoError_();

        // Use shader program
        glUseProgram(theProgram.name);

        // Update attribute values
        glBindBuffer(GL_ARRAY_BUFFER, theVertices.name);
        glVertexAttribPointer(theVertexAttributeIndex, 2, GL_FLOAT, GL_FALSE, 0, 0);
        glEnableVertexAttribArray(theVertexAttributeIndex);

        glBindBuffer(GL_ARRAY_BUFFER, theTextureVertexBuffer.name);
        glVertexAttribPointer(theTextureAttributeIndex, 2, GL_FLOAT, GL_FALSE, 0, 0);
        glEnableVertexAttribArray(theTextureAttributeIndex);

        glBindTexture(GL_TEXTURE_2D, self.texture.name);

        // Update uniform values
        glUniformMatrix4fv(theTransformUniformIndex, 1, NO, &inTransform.m00);

        AssertOpenGLNoError_();
        
        // Validate program before drawing. This is a good check, but only really necessary in a debug build. DEBUG macro must be defined in your debug configurations if that's not already the case.
    #if defined(DEBUG)
        NSError *theError = NULL;
        if ([theProgram validate:&theError] == NO)
            {
            NSLog(@"Failed to validate program: %@", theError);
            return;
            }
    #endif

        // Draw
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        };
    }

@end