struct LightSourceParameters {
//    vec4 ambient;
    vec4 diffuse;
//    vec4 specular;
    vec4 position;
//    vec4 halfVector;
//    vec3 spotDirection;
//    float spotExponent;
//    float spotCutoff; // (range: [0.0,90.0], 180.0)
//    float spotCosCutoff; // (range: [1.0,0.0],-1.0)
//    float constantAttenuation;
//    float linearAttenuation;
//    float quadraticAttenuation;
    };

struct LightModelParameters {
    vec4 diffuse;
//    vec4 ambient;
    };

// ######################################################################

//uniform LightSourceParameters u_LightSource;
//uniform LightModelParameters u_LightModel;

varying vec4 v_color;

attribute vec4 a_position;
attribute vec3 a_normal; // gl_Normal

uniform mat4 u_modelViewMatrix;
uniform mat4 u_projectionMatrix;
//uniform mat3 u_normalMatrix; // gl_NormalMatrix

void main()
    {
    LightSourceParameters u_LightSource = LightSourceParameters(
        vec4(1, 1, 1, 1),
        vec4(1, 1, 1, 1)
        );
    LightModelParameters u_LightModel = LightModelParameters(
        vec4(1, 0, 0, 1)
        );
    mat3 u_normalMatrix = mat3(1, 0, 0,
                               0, 1, 0,
                               0, 0, 1);

    /* first transform the normal into eye space and normalize the result */
    vec3 normal = normalize(u_normalMatrix * a_normal);

    /* now normalize the light's direction. Note that according to the
    OpenGL specification, the light is stored in eye space. Also since
    we're talking about a directional light, the position field is actually
    direction */
    vec3 lightDir = normalize(vec3(u_LightSource.position));

    /* compute the cos of the angle between the normal and lights direction.
    The light is directional so the direction is constant for every vertex.
    Since these two are normalized the cosine is the dot product. We also
    need to clamp the result to the [0,1] range. */
    float NdotL = max(dot(normal, lightDir), 0.0);

    /* Compute the diffuse term */
    vec4 diffuse = u_LightModel.diffuse * u_LightSource.diffuse;
    v_color =  NdotL * diffuse;
//    v_color = vec4(1, 0, 0, 1);
    v_color.a = 1.0;

    gl_Position = u_modelViewMatrix * u_projectionMatrix * a_position;
    }