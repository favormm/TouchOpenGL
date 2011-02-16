//
//  CTestRenderer.m
//  Racing Gene
//
//  Created by Jonathan Wight on 01/22/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CTestRenderer.h"

#import "OpenGLTypes.h"
#import "CProgram.h"
#import "CShader.h"
#import "CVertexBuffer.h"
#import "CVertexBuffer_FactoryExtensions.h"
#import "CImageTextureLoader.h"
#import "CTexture.h"

@interface CTestRenderer ()
@property (readwrite, nonatomic, assign) BOOL setupDone;

- (void)setup;
@end

#pragma mark -

@implementation CTestRenderer

@synthesize setupDone;

- (id)init
    {
    if ((self = [super init]) != NULL)
        {
        }
    return(self);
    }
    
- (void)render
    {
    if (self.setupDone == NO)
        {
        [self setup];
        self.setupDone = YES;
        }
        
    [super render];
    }

- (void)setup
    {
    NSArray *theShaders = [NSArray arrayWithObjects:   
        [[[CShader alloc] initWithName:@"Texture.fsh"] autorelease],
        [[[CShader alloc] initWithName:@"Texture.vsh"] autorelease],
        NULL];
    
    CProgram *theProgram = [[[CProgram alloc] initWithFiles:theShaders] autorelease];

    // Geometry Vertices
    CVertexBuffer *theVertices = [CVertexBuffer vertexBufferWithRect:(CGRect){ -1, -1, 2, 2 }];
    CVertexBuffer *theTextureVertexBuffer = [CVertexBuffer vertexBufferWithRect:(CGRect){ 0, 0, 1, 1 }];

    // Colors
    CVertexBuffer *theColors = [CVertexBuffer vertexBufferWithColors:[NSArray arrayWithObjects:
        [UIColor redColor],
        [UIColor redColor],
        [UIColor redColor],
        [UIColor redColor],
        NULL]];
        
    
    
    CImageTextureLoader *theLoader = [[[CImageTextureLoader alloc] init] autorelease];
    CTexture *theTexture = [theLoader textureWithImageNamed:@"Brick" error:NULL];

    GLuint theVertexAttributeIndex = [theProgram attributeIndexForName:@"vertex"];
    GLuint theTextureAttributeIndex = [theProgram attributeIndexForName:@"texture"];
    GLuint theColorAttributeIndex = [theProgram attributeIndexForName:@"color"];
    
    GLuint theTransformUniformIndex = [theProgram uniformIndexForName:@"transform"];
    
    
    self.renderBlock = ^(void) {

        NSLog(@"RENDER");

        AssertOpenGLNoError_();

        // Use shader program
        glUseProgram(theProgram.name);

        // Update attribute values
        glBindBuffer(GL_ARRAY_BUFFER, theVertices.name);
        glVertexAttribPointer(theVertexAttributeIndex, 2, GL_FLOAT, GL_FALSE, 0, 0);
        glEnableVertexAttribArray(theVertexAttributeIndex);

        glBindBuffer(GL_ARRAY_BUFFER, theColors.name);
        glVertexAttribPointer(theColorAttributeIndex, 4, GL_UNSIGNED_BYTE, GL_TRUE, 0, 0);
        glEnableVertexAttribArray(theColorAttributeIndex);

        glBindBuffer(GL_ARRAY_BUFFER, theTextureVertexBuffer.name);
        glVertexAttribPointer(theTextureAttributeIndex, 2, GL_FLOAT, GL_FALSE, 0, 0);
        glEnableVertexAttribArray(theTextureAttributeIndex);

        glBindTexture(GL_TEXTURE_2D, theTexture.name);

        // Update uniform values
        Matrix4 theMatrix = Matrix4MakeScale(1, 1, 1);
        glUniformMatrix4fv(theTransformUniformIndex, 1, NO, &theMatrix.m00);

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
