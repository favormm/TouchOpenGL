//
//  CVertexBufferReference_PropertyListRepresentation.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/21/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CVertexBufferReference_PropertyListRepresentation.h"

#import "OpenGLTypes.h"
#import "CVertexBuffer.h"

#define NO_DEFAULTS 1

@implementation CVertexBufferReference (CVertexBufferReference_PropertyListRepresentation)

- (id)initWithPropertyListRepresentation:(id)inRepresentation error:(NSError **)outError;
	{
    NSString *theString = [(NSDictionary *)inRepresentation objectForKey:@"size"];
    NSAssert(NO_DEFAULTS && theString.length > 0, @"No size specified.");
    GLint theSize = [theString intValue] ?: 3;

    theString = [(NSDictionary *)inRepresentation objectForKey:@"type"];
    NSAssert(NO_DEFAULTS && theString.length > 0, @"No type specified.");
    GLenum theType = GLenumFromString(theString) ?: GL_FLOAT;

    theString = [(NSDictionary *)inRepresentation objectForKey:@"normalized"];
    NSAssert(NO_DEFAULTS && theString.length > 0, @"No normalized specified.");
    GLboolean theNormalized = [theString boolValue] ?: GL_FALSE;

    theString = [(NSDictionary *)inRepresentation objectForKey:@"stride"];
    NSAssert(NO_DEFAULTS && theString.length > 0, @"No stride specified.");
    GLint theStride = [theString intValue] ?: 3;

    theString = [(NSDictionary *)inRepresentation objectForKey:@"offset"];
    NSAssert(NO_DEFAULTS && theString.length > 0, @"No offset specified.");
    GLint theOffset = [theString intValue] ?: 3;

    NSDictionary *theVBODictionary = [(NSDictionary *)inRepresentation objectForKey:@"VBO"];
//    CVertexBuffer *theVertexBuffer = [self vertexBufferWithDictionary:theVBODictionary error:outError];
    CVertexBuffer *theVertexBuffer = NULL;

    GLint theRowSize = 0;

    if (theType == GL_FLOAT)
        {
        theRowSize = sizeof(GLfloat) *theSize;
        }

    if (theVertexBuffer.data.length % theRowSize != 0)
        {
        if (outError != NULL)
            {
            *outError = [NSError errorWithDomain:@"TODO_DOMAIN" code:-1 userInfo:NULL];
            }
        return(NULL);
        }

    GLint theRowCount = theVertexBuffer.data.length / theRowSize;



	if ((self = [self initWithVertexBuffer:theVertexBuffer rowSize:theRowSize rowCount:theRowCount size:theSize type:theType normalized:theNormalized stride:theStride offset:theOffset]) != NULL)
		{
		}
	return(self);
	}


@end
