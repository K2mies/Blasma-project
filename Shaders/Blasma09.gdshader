shader_type canvas_item;
/*
*	MIXED LUT RADIAL SHADER
*	attempt at mixing two lut radial waves together
*/

// -------------------------------------------------------------------- uniforms
uniform sampler2D	lut_texture;
uniform vec4		wave_params[2];
uniform float		u_time = 0.f;
uniform float		u_speed = 1.0f;
uniform vec2		u_resolution = vec2( 1024.f, 768.f);
uniform float		u_value = .5f;

// ------------------------------------------------------------------- functions
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

	// third wave possible but must change max_functions to 3.f
	// and change to uniform wave_params[3]
	//vec4 p3 = wave_params[wave_c];
	//s += radialWave( st, p3.x, p3.y, p3.z + TIME * u_speed, p3.w );

	s /= max_functions; //creates fractional value

	// ------------------------------------------------------------------------- lut
	vec4 final_color = texture( lut_texture, vec2( s, 0.5 ) );

	// ---------------------------------------------------------------------- output
	COLOR = clamp( final_color, 0, 1 );
}