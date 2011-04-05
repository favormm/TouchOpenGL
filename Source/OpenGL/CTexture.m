//
//  CTexture.m
//  Racing Genes
//
//  Created by Jonathan Wight on 09/06/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CTexture.h"

@implementation CTexture

@synthesize name;
@synthesize size;
@synthesize internalFormat;
@synthesize hasAlpha;

- (id)initWithName:(GLuint)inName size:(SIntSize)inSize
    {
    if ((self = [super init]) != NULL)
        {
        name = inName;
        size = inSize;
        }
    return(self);
    }

- (void)dealloc
    {
    if (name != 0)
        {
        glDeleteTextures(1, &name);
        name = 0;
        }
    //
    [super dealloc];
    }

- (BOOL)isValid
    {
    return(glIsTexture(self.name));
    }
    
@end
