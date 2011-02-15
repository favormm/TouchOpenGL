//
//  Shader.vsh
//  Racing Genes
//
//  Created by Jonathan Wight on 09/05/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//


attribute vec4 vertex;
attribute vec4 color;

uniform mat4 transform;
uniform vec4 u_color;

varying vec4 v_color;

void main()
    {
    v_color = u_color;
    gl_Position = transform * vertex;
    }
