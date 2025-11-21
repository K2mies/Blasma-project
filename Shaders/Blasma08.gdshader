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
float smoothWave(	vec2 coord,
					float vx,
					float vy,
					float phase,
					float length_scale
)
{
	vec2 direction = vec2( vx, vy );
	direction = normalize( direction );

	float dot_product = dot( direction, coord );
	float input_value = dot_product * length_scale + phase;

	return ( sin( input_value ) * u_value ) + u_value;
}

float radialWave(
					vec2 coord,
					float center_x,
					float center_y,
					float phase,
					float length_scale
)
{
	// 1. Calculate the distance vector (dx, dy)
	vec2 pos =						coord;
	vec2 centre =					vec2( center_x, center_y );
	vec2 distance_vector =			pos - centre;

	// 2. Calculate the magnitude of the distance vector (Math.sqrt(dx*dx + dy*dy))
	 float distance_from_centre = length( distance_vector );

	// 3. Apply scaling and phase shift
	float gradient = distance_from_centre * length_scale + phase;

	// 4. Apply Math.floor equivalent (creates the hard-edged steps/rings)
	//gradient = floor( gradient );

	return ( sin( gradient ) * u_value ) + u_value;
}

void fragment() {
	// ----------------------------------------------------------------------- enums
	int WAVE_A = 0;
	int WAVE_B = 1;
	int WAVE_C = 2;

	// ------------------------------------------------------------------- variables
	vec2 st = UV * 1.f;
	float s = 0.f;

	// ---------------------------------------------------------------- radial waves
	float max_functions = 2.f;
	vec4 p1 = wave_params[WAVE_A];
	s += radialWave( st, p1.x, p1.y, p1.z + TIME * u_speed, p1.w );

	vec4 p2 = wave_params[WAVE_B];
	s += radialWave( st, p2.x, p2.y, p2.z + TIME * u_speed, p2.w );

//	vec4 p3 = wave_params[WAVE_C];
//	s += radialWave( st, p3.x, p3.y, p3.z + TIME * u_speed, p3.w );

	// ---------------------------------------------------------------- smooth waves
//	vec4 p1 = wave_params[WAVE_A];
//	s += smoothWave( st, p1.x, p1.y, p1.z + TIME * u_speed, p1.w );

//	vec4 p2 = wave_params[WAVE_B];
//	s += smoothWave( st, p2.x, p2.y, p2.z + TIME * u_speed, p2.w );

//	vec4 p3 = wave_params[WAVE_C];
//	s += smoothWave( st, p3.x, p3.y, p3.z + TIME * u_speed, p3.w );

	s /= max_functions; //not exactly sure why this is needed but it seems to make a difference.
	// my guess would be because it creates a fractional value from those that have been added together.

	// ------------------------------------------------------------------------- lut
	vec4 final_color = texture( lut_texture, vec2( s, 0.5 ) );

	// ---------------------------------------------------------------------- output
	COLOR = clamp( final_color, 0, 1 );
}