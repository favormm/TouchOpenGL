/*
 *  OpenGLTypes.h
 *  Racing Gene
 *
 *  Created by Jonathan Wight on 09/07/10.
 *  Copyright 2010 toxicsoftware.com. All rights reserved.
 *
 */
 
#import "OpenGLIncludes.h"

typedef struct Vector2 {
    GLfloat x, y;
    } Vector2;
    
typedef struct Vector3 {
    GLfloat x, y, z;
    } Vector3;

typedef struct Vector4 {
    GLfloat x, y, z, w;
    } Vector4;

typedef struct Color4ub {
    GLubyte r,g,b,a;
    } Color4ub;

typedef struct Color4f {
    GLfloat r,g,b,a;
    } Color4f;

typedef struct Color3ub {
    GLubyte r,g,b;
    } Color3ub;

typedef struct Color3f {
    GLfloat r,g,b;
    } Color3f;

typedef struct SIntPoint {
    GLint x, y;
    } SIntPoint;

typedef struct SIntSize {
    GLint width, height;
    } SIntSize;

// TODO -- inline these suckers.

extern GLfloat DegreesToRadians(GLfloat inDegrees);
extern GLfloat RadiansToDegrees(GLfloat inDegrees);

#define D2R(v) DegreesToRadians((v))
#define R2D(v) RadiansToDegrees((v))

extern GLfloat Vector3Length(Vector3 inVector);
extern Vector3 Vector3CrossProduct(Vector3 inLHS, Vector3 inRHS);
extern GLfloat Vector3DotProduct(Vector3 inLHS, Vector3 inRHS);

extern GLenum GLenumFromString(NSString *inString);

#define AssertOpenGLNoError_() do { GLint theError = glGetError(); NSAssert1(theError == GL_NO_ERROR, @"Code entered with existing OGL error 0x%X", theError); } while(0)

