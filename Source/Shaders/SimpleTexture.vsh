//
//  Shader.vsh
//  Dwarfs
//
//  Created by Jonathan Wight on 09/05/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

attribute vec4 a_vertex;
attribute vec2 a_texture;

uniform mat4 u_transform;

varying vec2 v_texture0;

void main()
    {
    vec4 thePosition = u_transform * a_vertex;
    gl_Position = thePosition;

    v_texture0 = a_texture;
    }
