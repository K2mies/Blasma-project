shader_type canvas_item;

uniform vec2 direction =		vec2(10.0f, 0.f);
uniform float uv_scale =		1.f;
uniform float scale = 		20.f;
uniform float speed = 		5.f;
uniform float value =		0.5f;

float stripe( float x, float y, float vx, float vy, float phase, float Length )
{
	vec2 pos =				vec2( x, y );
	vec2 direction_v =		vec2( vx, vy );
	float dot_product =		dot( direction_v, pos );
	
	//stepped interpalation
	//float stepped_input = dot_product * Length_scale + phase;
	//float stepped_value = floor(stepped_input); // this forces the gradient to be stepped instead
	//float stepped_value = stepped_input;
	
	float gradient = dot_product * Length + phase; //gradient interpelation
	gradient = gradient * value + value;
	return sin( gradient );	
}

void fragment() {
	
	// 1. get the position and scale it up
	vec2 uv_scaled = UV * uv_scale;
	
	// 2. use TIME as the phase for animation
	float current_phase = TIME * speed;
	
	// 3. call your custom function
	float sin1 = stripe(
		uv_scaled.x,
		uv_scaled.y,
		direction.x,
		direction.y,
		current_phase,
		scale
	);

	// 4. adjust the output and apply to COLOR
	// Since the input to sin() is an integer, sin(integer) will just be a constant color
    // along each stripe.
	vec4 c = vec4( sin1, sin1, sin1, 1.f );
	COLOR = clamp( c, 0, 1 );
}

