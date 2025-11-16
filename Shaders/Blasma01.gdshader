shader_type canvas_item;

//uniform float scale = 10.0;
uniform float scale = 10.f;
uniform vec2 direction = vec2(1.f, 0.f);

float plane(float x, float y, float vx, float vy, float phase, float Length_scale )
{
	vec2 pos = vec2(x, y);
	vec2 direction_v = vec2(vx, vy);
	float dot_product = dot(direction_v, pos);
	//float stepped_input = dot_product * Length_scale + phase;
	//float stepped_value = floor(stepped_input); // this forces the gradient to be stepped instead
	//float stepped_value = stepped_input;
	float stepped_value = dot_product * Length_scale + phase;
	return sin(stepped_value);	
}

void fragment() {
	//get the position and scale it up
	vec2 uv_scaled = UV * 1.f;
	
	//use TIME as the phase for animation
	float current_phase = TIME * 5.f;
	
	//call your custom function
	float pattern_value = plane(
		uv_scaled.x,
		uv_scaled.y,
		direction.x,
		direction.y,
		current_phase,
		scale
	);
	
	//adjust the output and apply color
	// Since the input to sin() is an integer, sin(integer) will just be a constant color
    // along each stripe.
	float value = 0.5f;
	vec3 color = vec3(pattern_value * value + value); // Map to [0, 1] for visual output
	COLOR = vec4(color, 1.f);
}

