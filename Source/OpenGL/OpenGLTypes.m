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


extern GLfloat Vector3Length(Vector3 inVector)
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
    
GLfloat Vector3DotProduct(Vector3 inLHS, Vector3 inRHS)
    {
    return(inLHS.x * inRHS.x + inLHS.y * inRHS.y + inLHS.z * inRHS.z);
    }