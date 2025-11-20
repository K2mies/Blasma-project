shader_type canvas_item;
// -------------------------------------------------------------------- uniforms
uniform sampler2D	lut_texture;
uniform float 		uv_scale =			20.f;
uniform float 		ring_density = 		.4f;
uniform float 		center_offset_x =	10.f; //to center, half uv_scale
uniform float 		center_offset_y =	10.f; //to center, half uv_scale
uniform float 		speed =				3.f;

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
	vec2 pos =					vec2( x, y );
	vec2 centre =				vec2( center_x, center_y );
	vec2 distance_vector =		pos - centre;
	
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
	vec2 uv_scaled = UV * uv_scale; //scale up pattern coordinates
	
	// 2. Use TIME for animation
	float current_phase = TIME * speed;
	// -------------------------------------------------------------- function calls

	// 3. Radial function call
	float sin1 = radialWave(
		uv_scaled.x,
		uv_scaled.y,
		center_offset_x,
		center_offset_y,
		ring_density,
		current_phase
	);
	
	// -------------------------------------------------------------- texture lookup
	vec2 position = vec2( sin1, 0.5f );
	vec4 textured_color = texture( lut_texture, position );
	
	// ---------------------------------------------------------------------- output
	COLOR = clamp( textured_color, 0, 1 );
}

