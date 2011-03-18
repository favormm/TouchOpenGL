precision mediump float;

uniform vec4 u_ambient;
uniform vec4 u_specular;
uniform vec4 u_diffuse;

uniform float u_specularPower;
uniform sampler2D s_baseMap;
uniform sampler2D s_bumpMap;

varying vec2 v_texcoord;
varying vec3 v_viewDirection;
varying vec3 v_lightDirection;

void main(void)
	{
	// Fetch basemap color
	vec4 baseColor = texture2D(s_baseMap, v_texcoord);
	
	// Fetch the tangent-space normal from normal map
	vec3 normal = texture2D(s_bumpMap, v_texcoord).xyz;
	
	// Scale and bias from [0, 1] to [-1, 1] and normalize
	normal = normalize(normal * 2.0 - 1.0);
	
	// Normalize the light direction and view direction
	vec3 lightDirection = normalize(v_lightDirection);
	vec3 viewDirection = normalize(v_viewDirection);
	
	// Compute N.L 
	float nDotL = dot(normal, lightDirection);
	
	// Compute reflection vector
	vec3 reflection = (2.0 * normal * nDotL) - lightDirection;
	
	// Compute R.V
	float rDotV = max(0.0, dot(reflection, viewDirection));
	
	// Compute Ambient term
	vec4 ambient = u_ambient * baseColor;
	
	// Compute Diffuse term
	
	vec4 diffuse = u_diffuse * nDotL * baseColor;
	
	// Compute Specular term
	vec4 specular = u_specular * pow(rDotV, u_specularPower);
	
	// Output final color
	gl_FragColor = ambient + diffuse + specular;
	}
