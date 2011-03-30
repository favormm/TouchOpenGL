/*
 *  OpenGLTypes.h
 *  Racing Gene
 *
 *  Created by Jonathan Wight on 09/07/10.
 *  Copyright 2010 toxicsoftware.com. All rights reserved.
 *
 */

#import "Matrix.h"
 
#include <tgmath.h>

#import "OpenGLTypes.h"

#include <tgmath.h>

// Matrix4 code based on code from http://sunflow.sourceforge.net/

const Matrix4 Matrix4Identity = {
    .m = {
        { 1.0, 0.0, 0.0, 0.0 },
        { 0.0, 1.0, 0.0, 0.0 },
        { 0.0, 0.0, 1.0, 0.0 },
        { 0.0, 0.0, 0.0, 1.0 },
        }
    };

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
        .m = {
            { 1.0, 0.0, 0.0, 0.0 },
            { 0.0, 1.0, 0.0, 0.0 },
            { 0.0, 0.0, 1.0, 0.0 },
            { tx,  ty,  tz,  1.0 },
            }
        };
    return(theMatrix);
    }
    
Matrix4 Matrix4MakeScale(GLfloat sx, GLfloat sy, GLfloat sz)
    {
    const Matrix4 theMatrix = {
        .m = {
            { sx, 0.0, 0.0, 0.0 },
            { 0.0, sy, 0.0, 0.0 },
            { 0.0, 0.0, sz, 0.0 },
            { 0.0, 0.0, 0.0, 1.0 },
            }
        };
    return(theMatrix);
    }
    
Matrix4 Matrix4MakeRotation(GLfloat angle, GLfloat x, GLfloat y, GLfloat z)
    {
    Matrix4 m = {};
    const GLfloat invLen = 1.0 / sqrt(x * x + y * y + z * z);
    x *= invLen;
    y *= invLen;
    z *= invLen;
    const GLfloat s = sin(angle);
    const GLfloat c = cos(angle);
    const GLfloat t = 1.0 - c;
    m.m[0][0] = t * x * x + c;
    m.m[1][1] = t * y * y + c;
    m.m[2][2] = t * z * z + c;
    const GLfloat txy = t * x * y;
    const GLfloat sz = s * z;
    m.m[0][1] = txy - sz;
    m.m[1][0] = txy + sz;
    const GLfloat txz = t * x * z;
    const GLfloat sy = s * y;
    m.m[0][2] = txz + sy;
    m.m[2][0] = txz - sy;
    const GLfloat tyz = t * y * z;
    const GLfloat sx = s * x;
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
    
Matrix4 Matrix4Concat(Matrix4 LHS, Matrix4 RHS)
    {
    Matrix4 theMatrix = { 
        .m = { 
            {
            LHS.m[0][0] * RHS.m[0][0] + LHS.m[0][1] * RHS.m[1][0] + LHS.m[0][2] * RHS.m[2][0] + LHS.m[0][3] * RHS.m[3][0],
            LHS.m[0][0] * RHS.m[0][1] + LHS.m[0][1] * RHS.m[1][1] + LHS.m[0][2] * RHS.m[2][1] + LHS.m[0][3] * RHS.m[3][1],
            LHS.m[0][0] * RHS.m[0][2] + LHS.m[0][1] * RHS.m[1][2] + LHS.m[0][2] * RHS.m[2][2] + LHS.m[0][3] * RHS.m[3][2],
            LHS.m[0][0] * RHS.m[0][3] + LHS.m[0][1] * RHS.m[1][3] + LHS.m[0][2] * RHS.m[2][3] + LHS.m[0][3] * RHS.m[3][3],
            },
            {
            LHS.m[1][0] * RHS.m[0][0] + LHS.m[1][1] * RHS.m[1][0] + LHS.m[1][2] * RHS.m[2][0] + LHS.m[1][3] * RHS.m[3][0],
            LHS.m[1][0] * RHS.m[0][1] + LHS.m[1][1] * RHS.m[1][1] + LHS.m[1][2] * RHS.m[2][1] + LHS.m[1][3] * RHS.m[3][1],
            LHS.m[1][0] * RHS.m[0][2] + LHS.m[1][1] * RHS.m[1][2] + LHS.m[1][2] * RHS.m[2][2] + LHS.m[1][3] * RHS.m[3][2],
            LHS.m[1][0] * RHS.m[0][3] + LHS.m[1][1] * RHS.m[1][3] + LHS.m[1][2] * RHS.m[2][3] + LHS.m[1][3] * RHS.m[3][3],
            },
            {
            LHS.m[2][0] * RHS.m[0][0] + LHS.m[2][1] * RHS.m[1][0] + LHS.m[2][2] * RHS.m[2][0] + LHS.m[2][3] * RHS.m[3][0],
            LHS.m[2][0] * RHS.m[0][1] + LHS.m[2][1] * RHS.m[1][1] + LHS.m[2][2] * RHS.m[2][1] + LHS.m[2][3] * RHS.m[3][1],
            LHS.m[2][0] * RHS.m[0][2] + LHS.m[2][1] * RHS.m[1][2] + LHS.m[2][2] * RHS.m[2][2] + LHS.m[2][3] * RHS.m[3][2],
            LHS.m[2][0] * RHS.m[0][3] + LHS.m[2][1] * RHS.m[1][3] + LHS.m[2][2] * RHS.m[2][3] + LHS.m[2][3] * RHS.m[3][3],
            },
            {
            LHS.m[3][0] * RHS.m[0][0] + LHS.m[3][1] * RHS.m[1][0] + LHS.m[3][2] * RHS.m[2][0] + LHS.m[3][3] * RHS.m[3][0],
            LHS.m[3][0] * RHS.m[0][1] + LHS.m[3][1] * RHS.m[1][1] + LHS.m[3][2] * RHS.m[2][1] + LHS.m[3][3] * RHS.m[3][1],
            LHS.m[3][0] * RHS.m[0][2] + LHS.m[3][1] * RHS.m[1][2] + LHS.m[3][2] * RHS.m[2][2] + LHS.m[3][3] * RHS.m[3][2],
            LHS.m[3][0] * RHS.m[0][3] + LHS.m[3][1] * RHS.m[1][3] + LHS.m[3][2] * RHS.m[2][3] + LHS.m[3][3] * RHS.m[3][3],
            },
        }
    };
    return(theMatrix);
    }

//static void __gluMultMatricesf(const GLfloat a[16], const GLfloat b[16],
//                               GLfloat r[16])
//{
//    int i, j;
//
//    for (i = 0; i < 4; i++)
//    {
//        for (j = 0; j < 4; j++)
//        {
//            r[i*4+j] = a[i*4+0]*b[0*4+j] +
//                       a[i*4+1]*b[1*4+j] +
//                       a[i*4+2]*b[2*4+j] +
//                       a[i*4+3]*b[3*4+j];
//        }
//    }
//}
//
//
//Matrix4 Matrix4Concat(Matrix4 LHS, Matrix4 RHS)
//    {
//    Matrix4 theMatrix;
//    __gluMultMatricesf(&LHS.m[0][0], &RHS.m[0][0], &theMatrix.m[0][0]);
//    return(theMatrix);
//    }




    
Matrix4 Matrix4Invert(Matrix4 t)
    {
    const GLfloat A0 = t.m[0][0] * t.m[1][1] - t.m[0][1] * t.m[1][0];
    const GLfloat A1 = t.m[0][0] * t.m[1][2] - t.m[0][2] * t.m[1][0];
    const GLfloat A2 = t.m[0][0] * t.m[1][3] - t.m[0][3] * t.m[1][0];
    const GLfloat A3 = t.m[0][1] * t.m[1][2] - t.m[0][2] * t.m[1][1];
    const GLfloat A4 = t.m[0][1] * t.m[1][3] - t.m[0][3] * t.m[1][1];
    const GLfloat A5 = t.m[0][2] * t.m[1][3] - t.m[0][3] * t.m[1][2];

    const GLfloat B0 = t.m[2][0] * t.m[3][1] - t.m[2][1] * t.m[3][0];
    const GLfloat B1 = t.m[2][0] * t.m[3][2] - t.m[2][2] * t.m[3][0];
    const GLfloat B2 = t.m[2][0] * t.m[3][3] - t.m[2][3] * t.m[3][0];
    const GLfloat B3 = t.m[2][1] * t.m[3][2] - t.m[2][2] * t.m[3][1];
    const GLfloat B4 = t.m[2][1] * t.m[3][3] - t.m[2][3] * t.m[3][1];
    const GLfloat B5 = t.m[2][2] * t.m[3][3] - t.m[2][3] * t.m[3][2];

    const GLfloat det = A0 * B5 - A1 * B4 + A2 * B3 + A3 * B2 - A4 * B1 + A5 * B0;
    NSCAssert(fabs(det) >= 1e-12f, @"Not invertable");
    const GLfloat invDet = 1.0 / det;
    Matrix4 m = {
        .m = {
            {
            (+t.m[1][1] * B5 - t.m[1][2] * B4 + t.m[1][3] * B3) * invDet,
            (-t.m[1][0] * B5 + t.m[1][2] * B2 - t.m[1][3] * B1) * invDet,
            (+t.m[1][0] * B4 - t.m[1][1] * B2 + t.m[1][3] * B0) * invDet,
            (-t.m[1][0] * B3 + t.m[1][1] * B1 - t.m[1][2] * B0) * invDet,
            },
            {
            (-t.m[0][1] * B5 + t.m[0][2] * B4 - t.m[0][3] * B3) * invDet,
            (+t.m[0][0] * B5 - t.m[0][2] * B2 + t.m[0][3] * B1) * invDet,
            (-t.m[0][0] * B4 + t.m[0][1] * B2 - t.m[0][3] * B0) * invDet,
            (+t.m[0][0] * B3 - t.m[0][1] * B1 + t.m[0][2] * B0) * invDet,
            },
            {
            (+t.m[3][1] * A5 - t.m[3][2] * A4 + t.m[3][3] * A3) * invDet,
            (-t.m[3][0] * A5 + t.m[3][2] * A2 - t.m[3][3] * A1) * invDet,
            (+t.m[3][0] * A4 - t.m[3][1] * A2 + t.m[3][3] * A0) * invDet,
            (-t.m[3][0] * A3 + t.m[3][1] * A1 - t.m[3][2] * A0) * invDet,
            },
            {
            (-t.m[2][1] * A5 + t.m[2][2] * A4 - t.m[2][3] * A3) * invDet,
            (+t.m[2][0] * A5 - t.m[2][2] * A2 + t.m[2][3] * A1) * invDet,
            (-t.m[2][0] * A4 + t.m[2][1] * A2 - t.m[2][3] * A0) * invDet,
            (+t.m[2][0] * A3 - t.m[2][1] * A1 + t.m[2][2] * A0) * invDet,
            },
            }
        };
    return(m);
    }

Matrix4 Matrix4Transpose(Matrix4 t)
    {
    Matrix4 m;
    for (int X = 0; X != 4; ++X)
        {
        for (int Y = 0; Y != 4; ++X)
            {
            m.m[X][Y] = t.m[Y][X];
            }
        }
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

Matrix4 Matrix4FromPropertyListRepresentation(id inPropertyListRepresentation)
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

#pragma mark -

//Matrix4 Matrix4Perspective(GLfloat fov, GLfloat aspect, GLfloat znear, GLfloat zfar)
// {
//  float ymax = znear * tan(fov * M_PI / 180.0);
//  float ymin = -ymax;
//  float xmax = ymax * aspect;
//  float xmin = ymin * aspect;
//
//  float width = fabs(xmax - xmin);
//  float height = fabs(ymax - ymin);
//
//  float depth = zfar - znear;
//  float q = -(zfar + znear) / depth;
//  float qn = -2 * (zfar * znear) / depth;
//
//  float w = 2 * znear / width;
//  w = w / aspect;
//  float h = 2 * znear / height;
//
//    Matrix4 theMatrix;
//
//    float *m = &theMatrix.m[0][0];
//  m[0]  = w;
//  m[1]  = 0;
//  m[2]  = 0;
//  m[3]  = 0;
//
//  m[4]  = 0;
//  m[5]  = h;
//  m[6]  = 0;
//  m[7]  = 0;
//
//  m[8]  = 0;
//  m[9]  = 0;
//  m[10] = q;
//  m[11] = -1;
//
//  m[12] = 0;
//  m[13] = 0;
//  m[14] = qn;
//  m[15] = 0;
//  return(theMatrix);
// }


Matrix4 Matrix4Perspective(GLfloat fovy, GLfloat aspect, GLfloat zNear, GLfloat zFar)
    {
    Matrix4 m = Matrix4Identity;

    GLfloat sine, cotangent, deltaZ;
    GLfloat radians = fovy / 2 * M_PI / 180;

    deltaZ = zFar-zNear;
    sine = sin(radians);
    if ((deltaZ == 0) || (sine == 0) || (aspect == 0))
        {
        return(m);
        }
    cotangent = cos(radians) / sine;

    m.m[0][0] = cotangent / aspect;
    m.m[1][1] = cotangent;
    m.m[2][2] = -(zFar + zNear) / deltaZ;
    m.m[2][3] = -1;
    m.m[3][2] = -2 * zNear * zFar / deltaZ;
    m.m[3][3] = 0;
    return(m);
    }


Matrix4 Matrix4Ortho(float left, float right, float bottom, float top, float nearZ, float farZ)
    {
    float       deltaX = right - left;
    float       deltaY = top - bottom;
    float       deltaZ = farZ - nearZ;
    Matrix4    ortho = Matrix4Identity;

    if ( (deltaX == 0.0f) || (deltaY == 0.0f) || (deltaZ == 0.0f) )
        return(ortho);

        ortho.m[0][0] = 2.0f / deltaX;
    ortho.m[3][0] = -(right + left) / deltaX;
    ortho.m[1][1] = 2.0f / deltaY;
    ortho.m[3][1] = -(top + bottom) / deltaY;
    ortho.m[2][2] = -2.0f / deltaZ;
    ortho.m[3][2] = -(nearZ + farZ) / deltaZ;

    
    return(ortho);
    }

#pragma mark -

Matrix3 Matrix3FromMatrix4Lossy(Matrix4 a)
    {
    Matrix3 theMatrix = { .m = {
        { a.m[0][0], a.m[0][1], a.m[0][2], },
        { a.m[1][0], a.m[1][1], a.m[1][2], },
        { a.m[2][0], a.m[2][1], a.m[2][2], },
        }
        };
    return(theMatrix);
    }