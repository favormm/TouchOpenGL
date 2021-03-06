//
//  Shader.fsh
//  Dwarfs
//
//  Created by Jonathan Wight on 09/05/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

varying mediump vec2 v_texture0;
varying mediump vec4 v_color;

uniform sampler2D s_texture;

void main()
    {
    gl_FragColor = texture2D(s_texture, v_texture0) * v_color;
    }
