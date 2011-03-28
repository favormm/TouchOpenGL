struct LightSourceParameters {
    vec4 ambient;
    vec4 diffuse;
    vec4 specular;
    vec4 position;
    vec4 halfVector;
//    vec3 spotDirection;
//    float spotExponent;
//    float spotCutoff; // (range: [0.0,90.0], 180.0)
//    float spotCosCutoff; // (range: [1.0,0.0],-1.0)
//    float constantAttenuation;
//    float linearAttenuation;
//    float quadraticAttenuation;
    };

struct LightModelParameters {
    vec4 ambient;
	};

struct MaterialParameters {
//    vec4 emission;
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

void main()
    {
    // These hard code variables will become uniforms in the real app
    LightSourceParameters u_LightSource = LightSourceParameters(
        vec4(1, 1, 1, 1), // ambient
        vec4(1, 1, 1, 1), // diffuse
        vec4(1, 1, 1, 1), // specular
        vec4(0, 1, 1, 0), // position
        vec4(0, 0.5, 0.5, 0) // halfVector
        );
	LightModelParameters u_LightModel = LightModelParameters(
        vec4(0.2, 0.2, 0.2, 1) // ambient
        );
    MaterialParameters u_FrontMaterial = MaterialParameters(
        vec4(0.2, 0.25, 0.2, 1), //ambient 
        vec4(1, 0, 0, 1), // diffuse
        vec4(0, 0, 0, 1), // specular
        1.0 // shiness
        );
        
    
    // this matrix is the transpose of the inverse of the 3×3 upper left sub matrix from the modelview matrix.
    mat3 u_normalMatrix = mat3(1, 0, 0, 0, 1, 0, 0, 0, 1);

    ////////////////////////////////////////////////////////////////////////////

    // First transform the normal into eye space and normalize the result.
    vec3 theNormal = normalize(u_normalMatrix * a_normal);

    // Mow normalize the light's direction. Note that according to the OpenGL specification, the light is stored in eye space. Also since we're talking about a directional light, the position field is actually direction
    vec3 theLightDirection = normalize(vec3(u_LightSource.position));

    // Compute the cos of the angle between the normal and lights direction. The light is directional so the direction is constant for every vertex. Since these two are normalized the cosine is the dot product. We also need to clamp the result to the [0,1] range.
    float NdotL = max(dot(theNormal, theLightDirection), 0.0);

    // Compute the diffuse term
    vec4 theDiffuseTerm = u_FrontMaterial.diffuse * u_LightSource.diffuse;

	// Compute the ambient and globalAmbient terms.
	vec4 ambient = u_FrontMaterial.ambient * u_LightSource.ambient;
	vec4 globalAmbient = u_LightModel.ambient * u_FrontMaterial.ambient;

    vec4 specular = vec4(0.0);
    if (NdotL > 0.0)
        {
        float NdotHV = max(dot(theNormal, u_LightSource.halfVector.xyz), 0.0);
		specular = u_FrontMaterial.specular * u_LightSource.specular * pow(NdotHV,u_FrontMaterial.shininess);
        }


    v_color = NdotL * theDiffuseTerm + globalAmbient + ambient + specular;



//    v_color = vec4(1, 0, 0, 1);
    v_color.a = 1.0;

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




