shader_type canvas_item;
/*
*	MIXED LUT RADIAL SHADER
*	attempt at mixing three lut radial waves together
*/

// -------------------------------------------------------------------- uniforms
uniform sampler2D	lut_texture;
uniform vec4		wave_params[3];

uniform float		u_time = 0.f;
uniform float		u_speed = 1.0f;
uniform vec2		u_resolution = vec2( 1024.f, 768.f);


// ------------------------------------------------------------------- functions
float smoothWave( vec2 coord, float vx, float vy, float phase, float length_scale ){
	vec2 direction = vec2( vx, vy );
	direction = normalize( direction );
	
	float dot_product = dot( direction, coord );
	float input_value = dot_product * length_scale + phase;
	
	return ( sin( input_value ) * .5f ) + .5f;
}

void fragment() {
	//fake enum values
	int wave1 = 0;
	int wave2 = 1;
	int wave3 = 2;
	
	vec2 st = UV * 1.f;
	
	float s = 0.f;
	
	float max_functions = 3.f;
	
	vec4 p1 = wave_params[wave1];
	s += smoothWave( st, p1.x, p1.y, p1.z + TIME * u_speed, p1.w );
	
	vec4 p2 = wave_params[wave2];
	s += smoothWave( st, p2.x, p2.y, p2.z + TIME * u_speed, p2.w );
	
	vec4 p3 = wave_params[wave3];
	s += smoothWave( st, p3.x, p3.y, p3.z + TIME * u_speed, p3.w );
	
	s /= max_functions;
	
	// ------------------------------------------------------------------------- lut
	vec4 final_color = texture( lut_texture, vec2( s, 0.5 ) );
	
	// ---------------------------------------------------------------------- output
	COLOR = clamp( final_color, 0, 1 );
}