//
//  Shader.vsh
//  Dwarfs
//
//  Created by Jonathan Wight on 09/05/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

struct directional_light {
	vec3 direction;
	vec3 halfplane;
	vec4 ambient_color;
	vec4 diffuse_color;
	vec4 specular_color;
};

struct material_properties {
	vec4 ambient_color;
	vec4 diffuse_color;
	vec4 specular_color;
	float specular_exponent;
};

uniform mat4 u_mvpMatrix;
uniform mat3 u_modelViewMatrix;
//uniform material_properties u_material;
//uniform directional_light u_light;

attribute vec4 a_position;
attribute vec3 a_normal;

varying vec4 v_color;

const directional_light k_light = directional_light(
    vec3(0.7, 0.7, 0.0),      // direction;
    vec3(0.7, 0.7, 0.0),      // halfplane;
    vec4(1.0, 0.0, 0.0, 1.0), // ambient_color;
    vec4(1.0, 0.0, 0.0, 1.0), // diffuse_color
    vec4(1.0, 0.0, 0.0, 1.0)  // specular_color
    );
const material_properties k_material = material_properties(
    vec4(1.0, 1.0, 1.0, 1.0), // ambient_color
    vec4(1.0, 1.0, 1.0, 1.0), // diffuse_color
    vec4(1.0, 1.0, 1.0, 1.0), // specular_color
    10.0 // specular_exponent
    );


vec4 compute_color(vec3 normal)
{
	vec4 computed_color = vec4(0.0, 0.0, 0.0, 0.0);
	float ndotl = max(0.0, dot(normal, k_light.direction));
	float ndoth = max(0.0, dot(normal, k_light.halfplane));
	
	computed_color += k_light.ambient_color * k_material.ambient_color;
	computed_color += ndotl * k_light.diffuse_color * k_material.diffuse_color;
	
	if (ndoth > 0.0)
        {
		computed_color += pow(ndoth, k_material.specular_exponent) * k_material.specular_color * k_light.specular_color;
        }
	return computed_color;
}

void main()
{
	gl_Position = u_mvpMatrix * a_position;
	v_color = compute_color(normalize(u_modelViewMatrix * a_normal));
    v_color.a = 1.0;
}
