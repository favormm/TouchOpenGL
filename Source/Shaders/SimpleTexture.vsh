//
//  Shader.vsh
//  Dwarfs
//
//  Created by Jonathan Wight on 09/05/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

attribute vec4 a_position;
attribute vec2 a_texCoord;

uniform mat4 u_modelViewMatrix;
uniform mat4 u_projectionMatrix;

varying vec2 v_texture0;

void main()
    {
    v_texture0 = a_texCoord;
    gl_Position = u_modelViewMatrix * u_projectionMatrix * a_position;
    }
