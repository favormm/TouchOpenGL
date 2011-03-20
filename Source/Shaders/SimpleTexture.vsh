//
//  Shader.vsh
//  Dwarfs
//
//  Created by Jonathan Wight on 09/05/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

attribute vec4 a_position;
attribute vec2 a_texCoord;

uniform mat4 u_mvpMatrix;
uniform mat4 u_modelViewMatrix;

varying vec2 v_texture0;

void main()
    {
    vec4 thePosition = u_mvpMatrix * a_position;
    gl_Position = thePosition;

    v_texture0 = a_texCoord;
    }
