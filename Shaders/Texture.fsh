//
//  Shader.fsh
//  Dwarfs
//
//  Created by Jonathan Wight on 09/05/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

varying mediump vec2 textureCoordinate;
varying mediump vec4 colorVarying;

uniform sampler2D s_texture;

void main()
    {
    gl_FragColor = texture2D(s_texture, textureCoordinate);
//    gl_FragColor = colorVarying;
    }
