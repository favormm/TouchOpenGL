//
//  CSketchCanvas.m
//  SketchTest
//
//  Created by Jonathan Wight on 02/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CSketchCanvas.h"

#import "CProgram.h"

#import "CShader.h"
#import "CImageRenderer.h"
#import "CVertexBuffer.h"
#import "CVertexBuffer_FactoryExtensions.h"
#import "UIColor_OpenGLExtensions.h"

@interface CSketchCanvas ()
@property (readwrite, nonatomic, retain) CProgram *program;
@property (readwrite, nonatomic, retain) CVertexBuffer *geometryCoordinates;
@end

#pragma mark -

@implementation CSketchCanvas

@synthesize imageRenderer;

@synthesize program;
@synthesize geometryCoordinates;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        imageRenderer = [[CImageRenderer alloc] initWithSize:(SIntSize){ 512, 512 }];

        imageRenderer.prerenderBlock = ^(void) {
            glEnable(GL_BLEND);
            glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

            glEnable(GL_DEPTH_TEST);

            glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
            glClearDepthf(1.0f);

            glClear(GL_DEPTH_BUFFER_BIT);
            };

        
        NSArray *theShaders = [NSArray arrayWithObjects:   
            [[[CShader alloc] initWithName:@"Flat.fsh"] autorelease],
            [[[CShader alloc] initWithName:@"Flat.vsh"] autorelease],
            NULL];
        
        program = [[CProgram alloc] initWithFiles:theShaders];

        NSError *theError = NULL;
        if ([self.program validate:&theError] == NO)
            {
            NSLog(@"Failed to validate program: %@", theError);
            }
        
        // Geometry Vertices
        self.geometryCoordinates = [CVertexBuffer vertexBufferWithRect:(CGRect){ -0.5, -0.5, 1, 1 }];
		}
	return(self);
	}

- (void)drawAtPoint:(CGPoint)inPoint
    {
    self.imageRenderer.renderBlock = ^(Matrix4 inTransform) {

        GLuint theVertexAttributeIndex = [self.program attributeIndexForName:@"vertex"];
        GLuint theColorUniformIndex = [self.program uniformIndexForName:@"u_color"];
        GLuint theTransformUniformIndex = [self.program uniformIndexForName:@"transform"];
    
        AssertOpenGLNoError_();

        // Use shader program
        glUseProgram(self.program.name);

        // Update attribute values
        glBindBuffer(GL_ARRAY_BUFFER, self.geometryCoordinates.name);
        glVertexAttribPointer(theVertexAttributeIndex, 2, GL_FLOAT, GL_FALSE, 0, 0);
        glEnableVertexAttribArray(theVertexAttributeIndex);

        // Update uniform values
        
        Color4f theColor = [UIColor greenColor].color4f;
        
        glUniform4fv(theColorUniformIndex, 1, &theColor.r);
        glUniformMatrix4fv(theTransformUniformIndex, 1, NO, &inTransform.m00);

        // Validate program before drawing. This is a good check, but only really necessary in a debug build. DEBUG macro must be defined in your debug configurations if that's not already the case.

#if defined(DEBUG)
        NSError *theError = NULL;
        if ([self.program validate:&theError] == NO)
            {
            NSLog(@"Failed to validate program: %@", theError);
            return;
            }
#endif

        // Draw
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);





        };
    [self.imageRenderer render];

    }

@end
