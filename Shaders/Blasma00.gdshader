shader_type canvas_item;

//uniform float speed = 1.f;
uniform float speed = 1.f;
uniform float amplitude = 1.f;

void fragment() {
	//vec4 color_at = vec4(sin(TIME), cos(TIME), 0.5, 1.0);
	//COLOR = mix(COLOR, color_at, 1.0);
	
	// make a simple sine curve for the full Blasma effect you would
	//have several of these
	float sin1 = (sin(TIME * speed) + 1.f) * 0.5f * amplitude;
	// just intermediate color variable to avoid nested function calls
	//which are annoying to read
	vec4 c = vec4(sin1, 0.f, 0.f, 1.f);
	//in glsl this should be saturate() it's a more performant
	// function than clamp. GDshader does not seem to have
	//saturate though
	COLOR = clamp(c, 0, 1);
}