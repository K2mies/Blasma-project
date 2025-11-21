shader_type canvas_item;
/*
*	LUT TEXTURE TEST
*	attempt at using a lut texture
*/

uniform sampler2D lut_texture;

void fragment() {
	//vec2 sample_coord =	UV;
	//vec2 sample_coord =	vec2(0.01, 0.f);
	//vec2 sample_coord =	vec2( sin( TIME * 0.1 ), 0.f );
	//vec2 sample_coord =	vec2( sin( TIME * 0.1 ), 0.f );
	vec2 sample_coord =		vec2( sin( TIME * 0.1f ), 0.f );
	vec4 sampled_color =	texture( lut_texture, sample_coord );
	COLOR =					clamp( sampled_color, 0, 1 );
}