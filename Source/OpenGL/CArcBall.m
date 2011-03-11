//
//  CArcBall.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/09/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CArcBall.h"

#include <tgmath.h>

#import "OpenGLTypes.h"
#import "Quaternion.h"

static GLfloat Epsilon = 1.0e-5f;

static Vector3 MapToSphere(CGPoint inPoint);

@interface CArcBall ()

@property (readwrite, nonatomic, assign) Vector3 startVector;          //Saved click vector
@property (readwrite, nonatomic, assign) Vector3 endVector;          //Saved drag vector
@property (readwrite, nonatomic, assign) Quaternion rotation;          //Saved drag vector

@end

#pragma mark -

@implementation CArcBall

@synthesize startVector;
@synthesize endVector;
@synthesize rotation;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        rotation = QuaternionIdentity;
		}
	return(self);
	}

- (Matrix4)rotationMatrix
    {
    return(Matrix4FromQuaternion(self.rotation));
    }

- (void)start:(CGPoint)inPoint
    {
    self.startVector = MapToSphere(inPoint);
    }
    
- (void)dragTo:(CGPoint)inPoint
    {
    Quaternion theRotation;

    // Map the point to the sphere
    self.endVector = MapToSphere(inPoint);

    Vector3 Perp = Vector3CrossProduct(self.startVector, self.endVector);

    // Compute the length of the perpendicular vector
    if (Vector3Length(Perp) > Epsilon)    //if its non-zero
        {
        // We're ok, so return the perpendicular vector as the transform after all
        theRotation.x = Perp.x;
        theRotation.y = Perp.y;
        theRotation.z = Perp.z;
        // In the quaternion values, w is cosine (theta / 2), where theta is rotation angle
        theRotation.w = Vector3DotProduct(self.startVector, self.endVector);
        }
    else                                    //if its zero
        {
        // The begin and end vectors coincide, so return an identity transform
        theRotation.x = theRotation.y = theRotation.z = theRotation.w = 0.0f;
        }

    self.rotation = theRotation;
    }

@end

static Vector3 MapToSphere(CGPoint inPoint)
    {
    // Compute the square of the length of the vector to the point from the center
    const GLfloat theLength = (inPoint.x * inPoint.x) + (inPoint.y * inPoint.y);

    Vector3 theVector;

    // If the point is mapped outside of the sphere... (length > radius squared)
    if (theLength > 1.0f)
        {
        // Compute a normalizing factor (radius / sqrt(length))
        const GLfloat theNormal = 1.0 / sqrt(theLength);

        // Return the "normalized" vector, a point on the sphere
        theVector.x = inPoint.x * theNormal;
        theVector.y = inPoint.y * theNormal;
        theVector.z = 0.0f;
        }
    else    //Else it's on the inside
        {
        // Return a vector to a point mapped inside the sphere 
        // sqrt(radius squared - length)
        theVector.x = inPoint.x;
        theVector.y = inPoint.y;
        theVector.z = sqrt(1.0 - theLength);
        }
    return(theVector);
    }
