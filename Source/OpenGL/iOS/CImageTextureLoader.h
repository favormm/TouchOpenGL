//
//  CImageTextureLoader.h
//  Dwarfs
//
//  Created by Jonathan Wight on 09/14/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CTextureLoader.h"

@interface CImageTextureLoader : CTextureLoader {

}

@property (readwrite, nonatomic, assign) BOOL scaleToNextLargestPowerOfTwo;


- (CTexture *)textureWithImage:(UIImage *)inImage error:(NSError **)outError;
- (CTexture *)textureWithImageNamed:(NSString *)inImageName error:(NSError **)outError;

@end
