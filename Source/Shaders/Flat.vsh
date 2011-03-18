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

varying vec4 v_color;

void main()
    {
    v_color = color;
//    v_color = vec4(1, 0, 0, 1);
    gl_Position = transform * vertex;
    }
