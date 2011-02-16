//
//  Shader.vsh
//  Dwarfs
//
//  Created by Jonathan Wight on 09/05/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

attribute vec4 vertex;
attribute vec2 texture;
attribute vec4 color;

uniform mat4 transform;

varying vec2 textureCoordinate;
varying vec4 colorVarying;

void main()
    {
    vec4 thePosition = transform * vertex;
    gl_Position = thePosition;

    textureCoordinate = texture;
    colorVarying = color;
    }
