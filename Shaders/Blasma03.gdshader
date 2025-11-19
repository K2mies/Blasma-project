shader_type canvas_item;
/*
*	FIRST MIXED SHADER
*	attempt at mixing a radial and a striped wave
*/

// ------------------------------------------------------------- shared uniforms
uniform float speed = 				5.f;
uniform float uv_scale =			20.f;
// ------------------------------------------------------------- stripe uniforms
uniform vec2 direction =			vec2(.2f, 0.f);
uniform float scale = 				20.f;
uniform float value =				.1f;
// ------------------------------------------------------------- radial uniforms
uniform float ring_density = 		.4f;
uniform float center_offset_x =		10.f;				//to center, half uv_scale
uniform float center_offset_y =		10.f;				//to center, half uv_scale

// ------------------------------------------------------------------- functions
float stripeWave(
	float x,
	float y,
	float vx,
	float vy,
	float phase,
	float Length
)
{
	vec2 pos =						vec2( x, y );
	vec2 direction_v =				vec2( vx, vy );
	float dot_product =				dot( direction_v, pos );
	float gradient = 				dot_product * Length + phase;
	gradient = 						gradient * value + value;
	
	return sin( gradient );	
}

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
	float distance_from_centre =	length( distance_vector );
	
	// 3. Apply scaling and phase shift
	float gradient = 				distance_from_centre * diameter + phase;
	
	return sin( gradient );
}
void fragment() {
	
	// ------------------------------------------------------------------- variables

	// 1. Get scaled UV coordinates
	vec2 uv_scaled = 		UV * uv_scale;
	
	// 2. Use TIME for animation
	float current_phase =	TIME * speed;
	
	// -------------------------------------------------------------- function calls
	// 3. striped function call
	float sin1 = stripeWave(
		uv_scaled.x,
		uv_scaled.y,
		direction.x,
		direction.y,
		current_phase,
		scale
	);
	
	// 3. Radial function call
	float sin2 = radialWave(
		uv_scaled.x,
		uv_scaled.y,
		center_offset_x,
		center_offset_y,
		ring_density,
		current_phase
	);
	
	// ----------------------------------------------------------------- wave mixings
	vec4 c1 = 	vec4( sin1, sin1, sin1, 1.f );
	vec4 c2 = 	vec4( sin2, sin2, sin2, 1.f );
	vec4 c =	mix( c1, c2, .5f );
	
	// ---------------------------------------------------------------------- output
	COLOR = clamp( c, 0, 1 );
}
