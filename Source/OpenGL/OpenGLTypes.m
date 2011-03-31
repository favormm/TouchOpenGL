/*
 *  OpenGLTypes.h
 *  Racing Gene
 *
 *  Created by Jonathan Wight on 09/07/10.
 *  Copyright 2010 toxicsoftware.com. All rights reserved.
 *
 */
 
#import "OpenGLTypes.h"

#include <tgmath.h>

GLfloat DegreesToRadians(GLfloat inDegrees)
	{
	return(inDegrees * M_PI / 180.0);
	}

GLfloat RadiansToDegrees(GLfloat inDegrees)
	{
	return(inDegrees * 180.0 / M_PI);
	}


GLfloat Vector3Length(Vector3 inVector)
    {
    return(sqrt(inVector.x * inVector.x + inVector.y * inVector.y + inVector.z * inVector.z));
    }

Vector3 Vector3CrossProduct(Vector3 inLHS, Vector3 inRHS)
    {
    Vector3 theCrossProduct = {
        .x = inLHS.y * inRHS.z - inLHS.z * inRHS.y,
        .y = inLHS.z * inRHS.x - inLHS.x * inRHS.z,
        .z = inLHS.x * inRHS.y - inLHS.y * inRHS.x,
        };
    return(theCrossProduct);
    }

Vector3 Vector3Add(Vector3 inLHS, Vector3 inRHS)
    {
    Vector3 theVector = {
        .x = inLHS.x + inRHS.x,
        .y = inLHS.y + inRHS.y,
        .z = inLHS.z + inRHS.z,
        };
    return(theVector);
    }
    
Vector3 Vector3FromVector4(Vector4 inVector)
    {
    Vector3 theVector = {
        .x = inVector.x,
        .y = inVector.y,
        .z = inVector.z
        };
    return(theVector);
    }
    
GLfloat Vector3DotProduct(Vector3 inLHS, Vector3 inRHS)
    {
    return(inLHS.x * inRHS.x + inLHS.y * inRHS.y + inLHS.z * inRHS.z);
    }

Vector3 Vector3Normalize(Vector3 inVector)
    {
    const GLfloat theLength = Vector3Length(inVector);
    return((Vector3){
        .x = inVector.x / theLength, 
        .y = inVector.y / theLength, 
        .z = inVector.z / theLength, 
        });
    }
    
NSString *NSStringFromVector3(Vector3 inVector)
	{
	return([NSString stringWithFormat:@"(%g, %g, %g)", inVector.x, inVector.y, inVector.z]);
	}
    
NSString *NSStringFromVector4(Vector4 inVector)
	{
	return([NSString stringWithFormat:@"(%g, %g, %g, %g)", inVector.x, inVector.y, inVector.z, inVector.w]);
	}

		
Color4f Color4fFromPropertyListRepresentation(id inPropertyListRepresentation)
    {
	Color4f theColor = { .a = 1.0 };
	NSArray *theArray = NULL;
	
	if ([inPropertyListRepresentation isKindOfClass:[NSString class]])
		{
        theArray = [inPropertyListRepresentation componentsSeparatedByString:@","];
        }
	else if ([inPropertyListRepresentation isKindOfClass:[NSArray class]])
		{
        theArray = inPropertyListRepresentation;
		}

    theColor.r = [[theArray objectAtIndex:0] doubleValue];
    theColor.g = [[theArray objectAtIndex:1] doubleValue];
    theColor.b = [[theArray objectAtIndex:2] doubleValue];
    if ([theArray count] == 4)
        {
        theColor.a = [[theArray objectAtIndex:3] doubleValue];
        }
    
    return(theColor);
    }
        
Vector3 Vector3FromPropertyListRepresentation(id inPropertyListRepresentation)
    {
	Vector3 theVector;
	NSArray *theArray = NULL;
	
	if ([inPropertyListRepresentation isKindOfClass:[NSString class]])
		{
        theArray = [inPropertyListRepresentation componentsSeparatedByString:@","];
        }
	else if ([inPropertyListRepresentation isKindOfClass:[NSArray class]])
		{
        theArray = inPropertyListRepresentation;
		}

    theVector.x = [[theArray objectAtIndex:0] doubleValue];
    theVector.y = [[theArray objectAtIndex:1] doubleValue];
    theVector.z = [[theArray objectAtIndex:2] doubleValue];
    
    return(theVector);
    }
    
GLenum GLenumFromString(NSString *inString)
    {
    // TODO obviously this needs to be massively expanded.
    if ([inString isEqualToString:@"GL_ARRAY_BUFFER"])
        {
        return(GL_ARRAY_BUFFER);
        }
    if ([inString isEqualToString:@"GL_ELEMENT_ARRAY_BUFFER"])
        {
        return(GL_ELEMENT_ARRAY_BUFFER);
        }
    else if ([inString isEqualToString:@"GL_STATIC_DRAW"])
        {
        return(GL_STATIC_DRAW);
        }
    else if ([inString isEqualToString:@"GL_FLOAT"])
        {
        return(GL_FLOAT);
        }
    else if ([inString isEqualToString:@"GL_SHORT"])
        {
        return(GL_SHORT);
        }
    else
        {
        NSCAssert(NO, @"Unknown enum");
        }
        
    return(0);   
    }
    
NSString *NSStringFromGLenum(GLenum inEnum)
    {
    switch (inEnum)
        {
        case GL_ARRAY_BUFFER:
            return(@"GL_ARRAY_BUFFER");
        case GL_ELEMENT_ARRAY_BUFFER:
            return(@"GL_ELEMENT_ARRAY_BUFFER");
        case GL_STATIC_DRAW:
            return(@"GL_STATIC_DRAW");
        case GL_FLOAT:
            return(@"GL_FLOAT");
        case GL_SHORT:
            return(@"GL_SHORT");
        default:
            {
            NSCAssert(NO, @"Unknown enum");
            }
            break;
        }
    return(NULL);
    }
    