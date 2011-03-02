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
#import "CVertexBufferReference.h"

@interface CSketchCanvas ()
@property (readwrite, nonatomic, retain) CProgram *program;
@property (readwrite, nonatomic, retain) CVertexBuffer *geometryCoordinates;
@property (readwrite, nonatomic, retain) CVertexBufferReference *geometryCoordinatesReference;
@end

#pragma mark -

@implementation CSketchCanvas

@synthesize size;
@synthesize imageRenderer;

@synthesize program;
@synthesize geometryCoordinates;
@synthesize geometryCoordinatesReference;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        size = (CGSize){ 512, 512 }; 
        
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
            [[[CShader alloc] initWithName:@"Brush.fsh"] autorelease],
            [[[CShader alloc] initWithName:@"Brush.vsh"] autorelease],
            NULL];
        
        program = [[CProgram alloc] initWithFiles:theShaders];

        NSError *theError = NULL;
        if ([self.program validate:&theError] == NO)
            {
            NSLog(@"Failed to validate program: %@", theError);
            }
        
        // Geometry Vertices
        const CGFloat F = 0.05;
        
//        self.geometryCoordinates = [CVertexBuffer vertexBufferWithRect:(CGRect){ -1.0 * F, -1.0 * F, 2.0 * F, 2.0 * F }];
        self.geometryCoordinates = [CVertexBuffer vertexBufferWithCircleWithRadius:F points:32];
        self.geometryCoordinatesReference = [[[CVertexBufferReference alloc] initWithVertexBuffer:self.geometryCoordinates cellEncoding:@encode(Vector2) normalized:NO stride:0] autorelease];
		}
	return(self);
	}

- (void)drawAtPoint:(CGPoint)inPoint
    {
    self.imageRenderer.renderBlock = ^(Matrix4 inTransform) {

        GLuint theVertexAttributeIndex = [self.program attributeIndexForName:@"vertex"];
        GLuint theColorUniformIndex = [self.program uniformIndexForName:@"u_color"];
//        GLuint thePointUniformIndex = [self.program uniformIndexForName:@"u_center"];
        GLuint theTransformUniformIndex = [self.program uniformIndexForName:@"u_transform"];
    
        AssertOpenGLNoError_();

        // Use shader program
        glUseProgram(self.program.name);

        // Update attribute values
        glBindBuffer(GL_ARRAY_BUFFER, self.geometryCoordinatesReference.vertexBuffer.name);
        glVertexAttribPointer(theVertexAttributeIndex, self.geometryCoordinatesReference.size, self.geometryCoordinatesReference.type, self.geometryCoordinatesReference.normalized, self.geometryCoordinatesReference.stride, 0);
        glEnableVertexAttribArray(theVertexAttributeIndex);

        // Update transform
        Vector4 thePoint = (Vector4){
            .x = inPoint.x / 512 * 2.0 - 1.0,
            .y = inPoint.y / 512 * 2.0 - 1.0,
            };
        inTransform = Matrix4Identity;        
        inTransform = Matrix4Translate(inTransform, thePoint.x, -thePoint.y, 0);
        glUniformMatrix4fv(theTransformUniformIndex, 1, NO, &inTransform.m00);

        // Update uniform values
        Color4f theColor = [UIColor blackColor].color4f;
        glUniform4fv(theColorUniformIndex, 1, &theColor.r);

        // Update point
//        glUniform4fv(thePointUniformIndex, 1, &thePoint.x);

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
        glDrawArrays(GL_TRIANGLE_FAN, 0, self.geometryCoordinatesReference.cellCount);


        // Update uniform values
        
        theColor = [UIColor blackColor].color4f;
        glUniform4fv(theColorUniformIndex, 1, &theColor.r);

        glDrawArrays(GL_LINE_STRIP, 0, self.geometryCoordinatesReference.cellCount);


        };
    [self.imageRenderer render];

    }

@end
