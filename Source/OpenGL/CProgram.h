//
//  CProgram.h
//  Racing Genes
//
//  Created by Jonathan Wight on 09/05/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OpenGLIncludes.h"

@interface CProgram : NSObject {
    NSArray *shaders;
    NSMutableDictionary *attributesByName;    
    NSMutableDictionary *uniformsByName;
    GLuint name;
}

@property (readonly, nonatomic, assign) GLuint name;

- (id)initWithName:(NSString *)inName attributeNames:(NSArray *)inAttributeNames uniformNames:(NSArray *)inUniformNames;

- (BOOL)linkProgram:(NSError **)outError;
- (BOOL)validate:(NSError **)outError;

- (void)use;

- (GLuint)attributeIndexForName:(NSString *)inName;
- (GLuint)uniformIndexForName:(NSString *)inName;

@end
