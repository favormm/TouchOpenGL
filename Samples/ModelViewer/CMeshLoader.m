//
//  CMeshLoader.m
//  ModelViewer
//
//  Created by Jonathan Wight on 03/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CMeshLoader.h"

#import "OpenGLIncludes.h"

#import "CTexture.h"
#import "CImageTextureLoader.h"
#import "CMesh.h"
#import "CVertexBuffer.h"
#import "CVertexBufferReference.h"
#import "OpenGLTypes.h"
#import "CMaterial.h"
#import "NSData_NumberExtensions.h"

@implementation CMeshLoader

- (NSArray *)loadMeshesFromFile:(NSString *)inName;
    {
    NSURL *theURL = [[NSBundle mainBundle] URLForResource:inName withExtension:@"model.plist"];
    NSDictionary *theDictionary = [NSDictionary dictionaryWithContentsOfURL:theURL];

    NSArray *theCenterArray = [theDictionary objectForKey:@"center"];

    Vector3 theCenter = {
        [[theCenterArray objectAtIndex:0] floatValue],
        [[theCenterArray objectAtIndex:1] floatValue],
        [[theCenterArray objectAtIndex:2] floatValue],
        };

    // Load materials.
    NSDictionary *theMaterialsDictionary = [theDictionary objectForKey:@"materials"];
    NSMutableDictionary *theMaterials = [NSMutableDictionary dictionary];
    
    for (NSString *theMaterialName in theMaterialsDictionary)
        {
        NSDictionary *theMaterialDictionary = [theMaterialsDictionary objectForKey:theMaterialName];
        
        CMaterial *theMaterial = [[[CMaterial alloc] initWithPropertyListRepresentation:theMaterialDictionary error:NULL] autorelease];
        [theMaterials setObject:theMaterial forKey:theMaterialName];
        }

    NSMutableArray *theMeshes = [NSMutableArray array];

    // Load meshs.
    NSArray *theMeshDictionaries = [theDictionary objectForKey:@"meshes"];
    for (NSDictionary *theMeshDictionary in theMeshDictionaries)
        {
        NSString *theMaterialName = [theMeshDictionary objectForKey:@"material"];

        NSString *theVerticesString = [theMeshDictionary objectForKey:@"vertices"];
        if (theVerticesString != NULL)
            {
            CMesh *theMesh = [[[CMesh alloc] init] autorelease];
            theMesh.center = theCenter;
			theMesh.material = [theMaterials objectForKey:theMaterialName];

            NSData *theData = [NSData dataWithNumbersInString:theVerticesString type:kCFNumberFloat32Type error:NULL];
            CVertexBuffer *theVertexBuffer = [[[CVertexBuffer alloc] initWithTarget:GL_ARRAY_BUFFER usage:GL_STATIC_DRAW data:theData] autorelease];
			size_t theRowCount = theVertexBuffer.data.length / sizeof(Vector3);
			theMesh.positions = [[[CVertexBufferReference alloc] initWithVertexBuffer:theVertexBuffer rowSize:sizeof(Vector3) rowCount:theRowCount size:3 type:GL_FLOAT normalized:NO stride:sizeof(Vector3) offset:0] autorelease];

            NSString *theVerticesString = [theMeshDictionary objectForKey:@"texCoords"];
            if (theVerticesString != NULL)
                {
                NSData *theData = [NSData dataWithNumbersInString:theVerticesString type:kCFNumberFloat32Type error:NULL];
                CVertexBuffer *theVertexBuffer = [[[CVertexBuffer alloc] initWithTarget:GL_ARRAY_BUFFER usage:GL_STATIC_DRAW data:theData] autorelease];
                size_t theRowCount = theVertexBuffer.data.length / sizeof(Vector2);
                theMesh.texCoords = [[[CVertexBufferReference alloc] initWithVertexBuffer:theVertexBuffer rowSize:sizeof(Vector2) rowCount:theRowCount size:2 type:GL_FLOAT normalized:NO stride:sizeof(Vector2) offset:0] autorelease];
                }

            theVerticesString = [theMeshDictionary objectForKey:@"normals"];
            if (theVerticesString != NULL)
                {
                NSData *theData = [NSData dataWithNumbersInString:theVerticesString type:kCFNumberFloat32Type error:NULL];
                CVertexBuffer *theVertexBuffer = [[[CVertexBuffer alloc] initWithTarget:GL_ARRAY_BUFFER usage:GL_STATIC_DRAW data:theData] autorelease];
                size_t theRowCount = theVertexBuffer.data.length / sizeof(Vector3);
                theMesh.normals = [[[CVertexBufferReference alloc] initWithVertexBuffer:theVertexBuffer rowSize:sizeof(Vector3) rowCount:theRowCount size:2 type:GL_FLOAT normalized:NO stride:sizeof(Vector3) offset:0] autorelease];
                }

            
			[theMeshes addObject:theMesh];
            }



        NSArray *theVBONames = [theMeshDictionary objectForKey:@"VBOs"];
		for (NSString *theVBOName in theVBONames)
			{
			CMesh *theMesh = [[[CMesh alloc] init] autorelease];
            theMesh.center = theCenter;
			theMesh.material = [theMaterials objectForKey:theMaterialName];

			NSURL *theURL = [[NSBundle mainBundle] URLForResource:theVBOName withExtension:@"vbo"];
			NSData *theData = [NSData dataWithContentsOfURL:theURL];
			
			size_t theRowSize = sizeof(Vector3) + sizeof(Vector2) + sizeof(Vector3);
			size_t theRowCount = theData.length / theRowSize;

			CVertexBuffer *theVertexBuffer = [[[CVertexBuffer alloc] initWithTarget:GL_ARRAY_BUFFER usage:GL_STATIC_DRAW data:theData] autorelease];

			GLint theStride = theRowSize;

			theMesh.positions = [[[CVertexBufferReference alloc] initWithVertexBuffer:theVertexBuffer rowSize:theRowSize rowCount:theRowCount size:3 type:GL_FLOAT normalized:NO stride:theStride offset:0] autorelease];
			theMesh.texCoords = [[[CVertexBufferReference alloc] initWithVertexBuffer:theVertexBuffer rowSize:theRowSize rowCount:theRowCount size:2 type:GL_FLOAT normalized:NO stride:theStride offset:sizeof(Vector3)] autorelease];
			
			[theMeshes addObject:theMesh];
			}
		}
    
    return(theMeshes); 
    }

@end
