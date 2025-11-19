shader_type canvas_item;

uniform float uv_scale =			20.f;
uniform float ring_density = 	10.f;
uniform float center_offset_x =	10.f;
uniform float center_offset_y =	10.f;
uniform float speed =			5.f;


float radial( float x, float y, float center_x, float center_y, float diameter, float phase )
{
	// 1. Calculate the distance vector (dx, dy)
	vec2 pos =				vec2( x, y );
	vec2 centre =			vec2( center_x, center_y );
	vec2 distance_vector =	pos - centre;
	
	// 2. Calculate the magnitude of the distance vector (Math.sqrt(dx*dx + dy*dy))
	// alternativley can use the 'length' function which does the same thing
	// float dist_from_centre = sqrt( dist_vec.x * dist_vec.x + dist_vec.y * dist_vec.y );
	 float distance_from_centre = length( distance_vector );
	
	// 3. Apply scaling and phase shift
	float gradient = distance_from_centre * diameter + phase;
	
	// 4. Apply Math.floor equivalent (creates the hard-edged steps/rings)
    //float stepped_value = floor(gradient);
	
	return sin( gradient );
}

void fragment() {
	
	// 1. Get scaled UV coordinates
	vec2 st = UV * uv_scale; //scale up pattern coordinates
	
	// 2. Use TIME for animation
	float current_phase = TIME * speed;
	
	// 3. Radial function call
	float sin1 = radial(
		st.x,
		st.y,
		center_offset_x,
		center_offset_y,
		ring_density,
		current_phase
	);
	
	// 4. clamped Output to COLOR
	vec4 c = vec4( sin1, sin1, sin1, 1.f );
	COLOR = clamp( c, 0, 1 );
	
}