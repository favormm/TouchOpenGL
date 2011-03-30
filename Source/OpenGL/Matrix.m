/*
 *  OpenGLTypes.h
 *  Racing Gene
 *
 *  Created by Jonathan Wight on 09/07/10.
 *  Copyright 2010 toxicsoftware.com. All rights reserved.
 *
 */

#import "Matrix.h"
 
#import "OpenGLTypes.h"

// Matrix4 code based on code from http://sunflow.sourceforge.net/

const Matrix4 Matrix4Identity = {
    1.0, 0.0, 0.0, 0.0,
    0.0, 1.0, 0.0, 0.0,
    0.0, 0.0, 1.0, 0.0,
    0.0, 0.0, 0.0, 1.0 };

BOOL Matrix4IsIdentity(Matrix4 t)
    {
    return(Matrix4EqualToTransform(t, Matrix4Identity));
    }

BOOL Matrix4EqualToTransform(Matrix4 a, Matrix4 b)
    {
    return(memcmp(&a, &b, sizeof(Matrix4)) == 0);
    }
    
Matrix4 Matrix4MakeTranslation(GLfloat tx, GLfloat ty, GLfloat tz)
    {
    const Matrix4 theMatrix = {
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        tx, ty, tz, 1.0 };
    return(theMatrix);
    }
    
Matrix4 Matrix4MakeScale(GLfloat sx, GLfloat sy, GLfloat sz)
    {
    const Matrix4 theMatrix = {
        sx, 0.0, 0.0, 0.0,
        0.0, sy, 0.0, 0.0,
        0.0, 0.0, sz, 0.0,
        0.0, 0.0, 0.0, 1.0 };
    return(theMatrix);
    }
    
Matrix4 Matrix4MakeRotation(GLfloat angle, GLfloat x, GLfloat y, GLfloat z)
    {
    Matrix4 m = {};
    float invLen = 1.0 / sqrtf(x * x + y * y + z * z);
    x *= invLen;
    y *= invLen;
    z *= invLen;
    float s = sinf(angle);
    float c = cosf(angle);
    float t = 1.0 - c;
    m.m[0][0] = t * x * x + c;
    m.m[1][1] = t * y * y + c;
    m.m[2][2] = t * z * z + c;
    float txy = t * x * y;
    float sz = s * z;
    m.m[0][1] = txy - sz;
    m.m[1][0] = txy + sz;
    float txz = t * x * z;
    float sy = s * y;
    m.m[0][2] = txz + sy;
    m.m[2][0] = txz - sy;
    float tyz = t * y * z;
    float sx = s * x;
    m.m[1][2] = tyz - sx;
    m.m[2][1] = tyz + sx;
    m.m[3][3] = 1.0;
    return m;
    }
    
Matrix4 Matrix4Translate(Matrix4 t, GLfloat tx, GLfloat ty, GLfloat tz)
    {
    return(Matrix4Concat(t, Matrix4MakeTranslation(tx, ty, tz)));
    }
    
Matrix4 Matrix4Scale(Matrix4 t, GLfloat sx, GLfloat sy, GLfloat sz)
    {
    return(Matrix4Concat(t, Matrix4MakeScale(sx, sy, sz)));
    }
    
Matrix4 Matrix4Rotate(Matrix4 t, GLfloat angle, GLfloat x, GLfloat y, GLfloat z)
    {
    return(Matrix4Concat(t, Matrix4MakeRotation(angle, x, y, z)));
    }
    
Matrix4 Matrix4Concat(Matrix4 a, Matrix4 m)
    {
    Matrix4 theMatrix = {
        a.m[0][0] * m.m[0][0] + a.m[0][1] * m.m[1][0] + a.m[0][2] * m.m[2][0] + a.m[0][3] * m.m[3][0],
        a.m[0][0] * m.m[0][1] + a.m[0][1] * m.m[1][1] + a.m[0][2] * m.m[2][1] + a.m[0][3] * m.m[3][1],
        a.m[0][0] * m.m[0][2] + a.m[0][1] * m.m[1][2] + a.m[0][2] * m.m[2][2] + a.m[0][3] * m.m[3][2],
        a.m[0][0] * m.m[0][3] + a.m[0][1] * m.m[1][3] + a.m[0][2] * m.m[2][3] + a.m[0][3] * m.m[3][3],

        a.m[1][0] * m.m[0][0] + a.m[1][1] * m.m[1][0] + a.m[1][2] * m.m[2][0] + a.m[1][3] * m.m[3][0],
        a.m[1][0] * m.m[0][1] + a.m[1][1] * m.m[1][1] + a.m[1][2] * m.m[2][1] + a.m[1][3] * m.m[3][1],
        a.m[1][0] * m.m[0][2] + a.m[1][1] * m.m[1][2] + a.m[1][2] * m.m[2][2] + a.m[1][3] * m.m[3][2],
        a.m[1][0] * m.m[0][3] + a.m[1][1] * m.m[1][3] + a.m[1][2] * m.m[2][3] + a.m[1][3] * m.m[3][3],

        a.m[2][0] * m.m[0][0] + a.m[2][1] * m.m[1][0] + a.m[2][2] * m.m[2][0] + a.m[2][3] * m.m[3][0],
        a.m[2][0] * m.m[0][1] + a.m[2][1] * m.m[1][1] + a.m[2][2] * m.m[2][1] + a.m[2][3] * m.m[3][1],
        a.m[2][0] * m.m[0][2] + a.m[2][1] * m.m[1][2] + a.m[2][2] * m.m[2][2] + a.m[2][3] * m.m[3][2],
        a.m[2][0] * m.m[0][3] + a.m[2][1] * m.m[1][3] + a.m[2][2] * m.m[2][3] + a.m[2][3] * m.m[3][3],

        a.m[3][0] * m.m[0][0] + a.m[3][1] * m.m[1][0] + a.m[3][2] * m.m[2][0] + a.m[3][3] * m.m[3][0],
        a.m[3][0] * m.m[0][1] + a.m[3][1] * m.m[1][1] + a.m[3][2] * m.m[2][1] + a.m[3][3] * m.m[3][1],
        a.m[3][0] * m.m[0][2] + a.m[3][1] * m.m[1][2] + a.m[3][2] * m.m[2][2] + a.m[3][3] * m.m[3][2],
        a.m[3][0] * m.m[0][3] + a.m[3][1] * m.m[1][3] + a.m[3][2] * m.m[2][3] + a.m[3][3] * m.m[3][3],
        };
    return(theMatrix);
    }
    
Matrix4 Matrix4Invert(Matrix4 t)
    {
    float A0 = t.m[0][0] * t.m[1][1] - t.m[0][1] * t.m[1][0];
    float A1 = t.m[0][0] * t.m[1][2] - t.m[0][2] * t.m[1][0];
    float A2 = t.m[0][0] * t.m[1][3] - t.m[0][3] * t.m[1][0];
    float A3 = t.m[0][1] * t.m[1][2] - t.m[0][2] * t.m[1][1];
    float A4 = t.m[0][1] * t.m[1][3] - t.m[0][3] * t.m[1][1];
    float A5 = t.m[0][2] * t.m[1][3] - t.m[0][3] * t.m[1][2];

    float B0 = t.m[2][0] * t.m[3][1] - t.m[2][1] * t.m[3][0];
    float B1 = t.m[2][0] * t.m[3][2] - t.m[2][2] * t.m[3][0];
    float B2 = t.m[2][0] * t.m[3][3] - t.m[2][3] * t.m[3][0];
    float B3 = t.m[2][1] * t.m[3][2] - t.m[2][2] * t.m[3][1];
    float B4 = t.m[2][1] * t.m[3][3] - t.m[2][3] * t.m[3][1];
    float B5 = t.m[2][2] * t.m[3][3] - t.m[2][3] * t.m[3][2];

    float det = A0 * B5 - A1 * B4 + A2 * B3 + A3 * B2 - A4 * B1 + A5 * B0;
    NSCAssert(fabs(det) >= 1e-12f, @"Not invertable");
    float invDet = 1.0 / det;
    Matrix4 m = {
        (+t.m[1][1] * B5 - t.m[1][2] * B4 + t.m[1][3] * B3) * invDet,
        (-t.m[1][0] * B5 + t.m[1][2] * B2 - t.m[1][3] * B1) * invDet,
        (+t.m[1][0] * B4 - t.m[1][1] * B2 + t.m[1][3] * B0) * invDet,
        (-t.m[1][0] * B3 + t.m[1][1] * B1 - t.m[1][2] * B0) * invDet,
        (-t.m[0][1] * B5 + t.m[0][2] * B4 - t.m[0][3] * B3) * invDet,
        (+t.m[0][0] * B5 - t.m[0][2] * B2 + t.m[0][3] * B1) * invDet,
        (-t.m[0][0] * B4 + t.m[0][1] * B2 - t.m[0][3] * B0) * invDet,
        (+t.m[0][0] * B3 - t.m[0][1] * B1 + t.m[0][2] * B0) * invDet,
        (+t.m[3][1] * A5 - t.m[3][2] * A4 + t.m[3][3] * A3) * invDet,
        (-t.m[3][0] * A5 + t.m[3][2] * A2 - t.m[3][3] * A1) * invDet,
        (+t.m[3][0] * A4 - t.m[3][1] * A2 + t.m[3][3] * A0) * invDet,
        (-t.m[3][0] * A3 + t.m[3][1] * A1 - t.m[3][2] * A0) * invDet,
        (-t.m[2][1] * A5 + t.m[2][2] * A4 - t.m[2][3] * A3) * invDet,
        (+t.m[2][0] * A5 - t.m[2][2] * A2 + t.m[2][3] * A1) * invDet,
        (-t.m[2][0] * A4 + t.m[2][1] * A2 - t.m[2][3] * A0) * invDet,
        (+t.m[2][0] * A3 - t.m[2][1] * A1 + t.m[2][2] * A0) * invDet,
        };
    return(m);
    }
    
NSString *NSStringFromMatrix4(Matrix4 t)
    {
    return([NSString stringWithFormat:@"{ %g, %g, %g, %g,\n%g, %g, %g, %g,\n%g, %g, %g, %g,\n%g, %g, %g, %g }",
        t.m[0][0], t.m[0][1], t.m[0][2], t.m[0][3],
        t.m[1][0], t.m[1][1], t.m[1][2], t.m[1][3],
        t.m[2][0], t.m[2][1], t.m[2][2], t.m[2][3],
        t.m[3][0], t.m[3][1], t.m[3][2], t.m[3][3]]);
    }

extern Matrix4 Matrix4FromPropertyListRepresentation(id inPropertyListRepresentation)
	{
	Matrix4 theMatrix = Matrix4Identity;
	
	if ([inPropertyListRepresentation isKindOfClass:[NSString class]])
		{
		NSCAssert(NO, @"Can't build a matrix from a string.");
		}
	else if ([inPropertyListRepresentation isKindOfClass:[NSArray class]])
		{
		theMatrix.m[0][0] = [[[inPropertyListRepresentation objectAtIndex:0] objectAtIndex:0] doubleValue];
		theMatrix.m[0][1] = [[[inPropertyListRepresentation objectAtIndex:0] objectAtIndex:1] doubleValue];
		theMatrix.m[0][2] = [[[inPropertyListRepresentation objectAtIndex:0] objectAtIndex:2] doubleValue];
		theMatrix.m[0][3] = [[[inPropertyListRepresentation objectAtIndex:0] objectAtIndex:3] doubleValue];

		theMatrix.m[1][0] = [[[inPropertyListRepresentation objectAtIndex:1] objectAtIndex:0] doubleValue];
		theMatrix.m[1][1] = [[[inPropertyListRepresentation objectAtIndex:1] objectAtIndex:1] doubleValue];
		theMatrix.m[1][2] = [[[inPropertyListRepresentation objectAtIndex:1] objectAtIndex:2] doubleValue];
		theMatrix.m[1][3] = [[[inPropertyListRepresentation objectAtIndex:1] objectAtIndex:3] doubleValue];

		theMatrix.m[2][0] = [[[inPropertyListRepresentation objectAtIndex:2] objectAtIndex:0] doubleValue];
		theMatrix.m[2][1] = [[[inPropertyListRepresentation objectAtIndex:2] objectAtIndex:1] doubleValue];
		theMatrix.m[2][2] = [[[inPropertyListRepresentation objectAtIndex:2] objectAtIndex:2] doubleValue];
		theMatrix.m[2][3] = [[[inPropertyListRepresentation objectAtIndex:2] objectAtIndex:3] doubleValue];

		theMatrix.m[3][0] = [[[inPropertyListRepresentation objectAtIndex:3] objectAtIndex:0] doubleValue];
		theMatrix.m[3][1] = [[[inPropertyListRepresentation objectAtIndex:3] objectAtIndex:1] doubleValue];
		theMatrix.m[3][2] = [[[inPropertyListRepresentation objectAtIndex:3] objectAtIndex:2] doubleValue];
		theMatrix.m[3][3] = [[[inPropertyListRepresentation objectAtIndex:3] objectAtIndex:3] doubleValue];
		}

	return(theMatrix);
	}






