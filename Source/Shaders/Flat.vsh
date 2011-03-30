//
//  Shader.vsh
//  Racing Genes
//
//  Created by Jonathan Wight on 09/05/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//


attribute vec4 a_position;
attribute vec4 a_color;

uniform mat4 u_modelViewMatrix;
uniform mat4 u_projectionMatrix;

varying vec4 v_color;

void main()
    {
    v_color = a_color;
    gl_Position = u_projectionMatrix * u_modelViewMatrix * a_position;
    }
