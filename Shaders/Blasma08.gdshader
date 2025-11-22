shader_type canvas_item;
/*
*	MIXED LUT SHADERS
*	attempt at mixing different waves together
*/

//*note to change number of waves must update wave_params[n]
// and change the max_functions variable to n.f
// can also update the gd script to pass default values to the shader.

// -------------------------------------------------------------------- uniforms
uniform sampler2D	lut_texture;
uniform vec4		wave_params[2];
uniform float		u_time = 0.f;
uniform float		u_speed = 1.0f;
uniform vec2		u_resolution = vec2( 1024.f, 768.f);
uniform float		u_value = .5f;

// ------------------------------------------------------------------- functions
float smoothWave(	vec2 coord,
					float vx,
					float vy,
					float phase,
					float length_scale
)
{
	vec2 direction =	vec2( vx, vy );
	direction =			normalize( direction );

	float dot_product = dot( direction, coord );
	float gradient = dot_product * length_scale + phase;
	
	//For stepped input
	//gradient = floor( gradient );

	gradient = sin( gradient );
	return ( gradient * u_value + u_value );
}

float radialWave(	vec2 coord,
					float center_x,
					float center_y,
					float phase,
					float length_scale
)
{
	vec2 pos =						coord;
	vec2 centre =					vec2( center_x, center_y );
	vec2 distance_vector =			pos - centre;


	float distance_from_centre =	length( distance_vector );
	float gradient = distance_from_centre * length_scale + phase;

	//For stepped input
	//gradient = floor( gradient );

	gradient = sin( gradient );
	return ( gradient * u_value + u_value );
}

void fragment() {
	// ----------------------------------------------------------------------- enums
	int wave_a = 0;
	int wave_b = 1;
	int wave_c = 2;

	// ------------------------------------------------------------------- variables
	vec2 st = UV * 1.f;
	float s = 0.f;

	// ---------------------------------------------------------------- radial waves
	float max_functions = 2.f;
	vec4 p1 = wave_params[wave_a];
	s += radialWave( st, p1.x, p1.y, p1.z + TIME * u_speed, p1.w );

	vec4 p2 = wave_params[wave_b];
	s += radialWave( st, p2.x, p2.y, p2.z + TIME * u_speed, p2.w );

//	vec4 p3 = wave_params[wave_c];
//	s += radialWave( st, p3.x, p3.y, p3.z + TIME * u_speed, p3.w );

	// ---------------------------------------------------------------- smooth waves
//	float max_functions = 3.f;
//	vec4 p1 = wave_params[wave_a];
//	s += smoothWave( st, p1.x, p1.y, p1.z + TIME * u_speed, p1.w );

//	vec4 p2 = wave_params[wave_b];
//	s += smoothWave( st, p2.x, p2.y, p2.z + TIME * u_speed, p2.w );

//	vec4 p3 = wave_params[wave_c];
//	s += smoothWave( st, p3.x, p3.y, p3.z + TIME * u_speed, p3.w );
	// ----------------------------------------------------------------- mixed waves
//	float max_functions = 2.f;
//	vec4 p1 = wave_params[wave_a];
//	s += radialWave( st, p1.x, p1.y, p1.z + TIME * u_speed, p1.w );
	
//	vec4 p2 = wave_params[wave_b];
//	s += smoothWave( st, p2.x, p2.y, p2.z + TIME * u_speed, p2.w );

	s /= max_functions; //not exactly sure why this is needed but it seems to make a difference.
	// my guess would be because it creates a fractional value from those that have been added together.

	// ------------------------------------------------------------------------- lut
	vec4 final_color = texture( lut_texture, vec2( s, 0.5 ) );

	// ---------------------------------------------------------------------- output
	COLOR = clamp( final_color, 0, 1 );
}