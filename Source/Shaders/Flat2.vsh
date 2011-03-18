//
//  Shader.vsh
//  Racing Genes
//
//  Created by Jonathan Wight on 09/05/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//


attribute vec4 vertex;
attribute vec4 normal;

uniform mat4 transform;
uniform vec4 u_diffuse_color;
uniform vec4 u_ambient_color;

varying vec4 v_color;

void main()
    {
    u_ambient_color;
    //
    v_color = u_diffuse_color;
    gl_Position = transform * vertex;
    }
