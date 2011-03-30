struct LightSourceParameters {
    vec4 ambient;
    vec4 diffuse;
    vec4 specular;
    vec4 position;
    vec4 halfVector;
    };

struct LightModelParameters {
    vec4 ambient;
	};

struct MaterialParameters {
    vec4 ambient;
    vec4 diffuse;
    vec4 specular;
    float shininess;
	};

// ######################################################################

varying vec4 v_color;

attribute vec4 a_position;
attribute vec3 a_normal; // gl_Normal

uniform mat4 u_modelViewMatrix;
uniform mat4 u_projectionMatrix;
//uniform mat3 u_normalMatrix; // gl_NormalMatrix

uniform LightSourceParameters u_lightSource;
uniform LightModelParameters u_lightModel;
uniform MaterialParameters u_frontMaterial;

void main()
    {
    // this matrix is the transpose of the inverse of the 3×3 upper left sub matrix from the modelview matrix.
    mat3 u_normalMatrix = mat3(1, 0, 0, 0, 1, 0, 0, 0, 1);

    ////////////////////////////////////////////////////////////////////////////

    // First transform the normal into eye space and normalize the result.
    vec3 theNormal = normalize(u_normalMatrix * a_normal);

    // Mow normalize the light's direction. Note that according to the OpenGL specification, the light is stored in eye space. Also since we're talking about a directional light, the position field is actually direction
    vec3 theLightDirection = normalize(vec3(u_lightSource.position));

    // Compute the cos of the angle between the normal and lights direction. The light is directional so the direction is constant for every vertex. Since these two are normalized the cosine is the dot product. We also need to clamp the result to the [0,1] range.
    float NdotL = max(dot(theNormal, theLightDirection), 0.0);

    // Compute the diffuse term
    vec4 theDiffuseTerm = u_frontMaterial.diffuse * u_lightSource.diffuse;

	// Compute the ambient and globalAmbient terms.
	vec4 ambient = u_frontMaterial.ambient * u_lightSource.ambient;
	vec4 globalAmbient = u_lightModel.ambient * u_frontMaterial.ambient;

    vec4 specular = vec4(0.0);
    if (NdotL > 0.0)
        {
        float NdotHV = max(dot(theNormal, u_lightSource.halfVector.xyz), 0.0);
		specular = u_frontMaterial.specular * u_lightSource.specular * pow(NdotHV,u_frontMaterial.shininess);
        }


    v_color = NdotL * theDiffuseTerm + globalAmbient + ambient + specular;

    gl_Position = u_modelViewMatrix * u_projectionMatrix * a_position;
    }
    
////////////////////////////////////////////////////////////////////////////////

//attribute vec4 a_position;
//attribute vec2 a_texCoord;
//
//uniform mat4 u_modelViewMatrix;
//uniform mat4 u_projectionMatrix;
//
//varying vec2 v_texture0;
//
//void main()
//    {
//    v_texture0 = a_texCoord;
//    gl_Position = u_modelViewMatrix * u_projectionMatrix * a_position;
//    }




