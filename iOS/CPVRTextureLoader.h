#import "CTextureLoader.h"

#if TARGET_OS_IPHONE == 1
#import <OpenGLES/ES2/gl.h>
#else
#import <OpenGL/OpenGL.h>
#endif

@interface CPVRTextureLoader : CTextureLoader {
	NSMutableArray *_imageData;
	GLuint _name;
	uint32_t _width, _height;
	GLenum _internalFormat;
	BOOL _hasAlpha;
}

@end
