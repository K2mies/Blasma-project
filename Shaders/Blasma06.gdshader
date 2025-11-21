shader_type canvas_item;
/*
*	MIXED LUT RADIAL SHADER
*	attempt at mixing two lut radial waves together
*/

// -------------------------------------------------------------------- uniforms
uniform sampler2D	lut_texture;
uniform float 		uv_scale =				20.f;
uniform float 		ring_density = 			.4f;
uniform float 		a_center_offset_x =		-0.5f;
uniform float 		a_center_offset_y =		0.f;
uniform float 		b_center_offset_x =		0.5f;
uniform float 		b_center_offset_y =		0.f;
uniform float 		speed =					3.f;

// ------------------------------------------------------------------- functions
float radialWave(
	float x, 
	float y, 
	float center_x, 
	float center_y, 
	float diameter, 
	float phase 
)
{
	// 1. Calculate the distance vector (dx, dy)
	vec2 pos =						vec2( x, y );
	vec2 centre =					vec2( center_x, center_y );
	vec2 distance_vector =			pos - centre;
	
	// 2. Calculate the magnitude of the distance vector (Math.sqrt(dx*dx + dy*dy))
	 float distance_from_centre = length( distance_vector );
	
	// 3. Apply scaling and phase shift
	float gradient = distance_from_centre * diameter + phase;
	
	// 4. Apply Math.floor equivalent (creates the hard-edged steps/rings)
	//gradient = floor( gradient );
	
	return sin( gradient );
}

void fragment() {
	// ------------------------------------------------------------------- variables
	// 1. Get scaled UV coordinates
	vec2 uv_scaled = 		UV * uv_scale; //scale up pattern coordinates
	
	// 2. Use TIME for animation
	float current_phase =	TIME * speed;
	// -------------------------------------------------------------- function calls

	float sin1 = radialWave(
		uv_scaled.x,
		uv_scaled.y,
		uv_scale * 0.5f + a_center_offset_x,
		uv_scale * 0.5f + a_center_offset_y,
		ring_density,
		current_phase
	);
	
		float sin2 = radialWave(
		uv_scaled.x,
		uv_scaled.y,
		uv_scale * 0.5f + b_center_offset_x,
		uv_scale * 0.5f + b_center_offset_y,
		ring_density,
		current_phase
	);
	
	// -------------------------------------------------------------- texture lookup
	sin1 *= 0.9f;
	sin2 *= 0.9f;
	vec2 position_a = 		vec2( sin1, 0.5f );
	vec2 position_b = 		vec2( sin2, 0.5f );
	vec4 c1 =				texture( lut_texture, position_a );
	vec4 c2 =				texture( lut_texture, position_b );
	
	// ------------------------------------------------------------------- mix waves
	//vec4 c = c1 + c2;
	//vec4 c = c1 / c2;
	vec4 c = mix(c1, c2, 0.5);

	// ---------------------------------------------------------------------- output
	COLOR = clamp( c, 0, 1 );
}