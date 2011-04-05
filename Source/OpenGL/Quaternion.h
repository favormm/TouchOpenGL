//
//  Quaternion.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/10/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "OpenGLTypes.h"

#import "Matrix.h"

typedef struct {
    GLfloat x, y, z, w;
} Quaternion;

extern Quaternion QuaternionIdentity;

extern Quaternion QuaternionSetAxisAngle(Vector3 inAxis, GLfloat inAngle);

extern GLfloat QuaternionLength2(Quaternion inQuat);
        
extern Quaternion QuaternionNormalize(Quaternion inQuat);
    
extern Quaternion QuaternionSetEuler(GLfloat inYaw, GLfloat inPitch, GLfloat inRoll);

extern void QuaternionGetEuler(Quaternion q, GLfloat *outYaw, GLfloat *outPitch, GLfloat *outRoll);
    
extern Quaternion QuaternionConjugate(Quaternion q);
        
extern Quaternion QuaternionMultiply(Quaternion inLHS, Quaternion inRHS);
    
extern Matrix4 Matrix4FromQuaternion(Quaternion q);

extern NSString *NSStringFromQuaternion(Quaternion q);
