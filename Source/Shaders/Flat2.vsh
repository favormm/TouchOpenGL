//
//  Shader.vsh
//  Racing Genes
//
//  Created by Jonathan Wight on 09/05/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//


attribute vec4 a_position;
attribute vec4 a_normal;

uniform mat4 u_modelViewMatrix;
uniform mat4 u_projectionMatrix;
uniform vec4 u_color;

varying vec4 v_color;

void main()
    {
    v_color = u_color;
    gl_Position = u_modelViewMatrix * u_projectionMatrix * a_position;
    }
