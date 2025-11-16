shader_type canvas_item;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform vec2 u_time;

void fragment() {
	vec2 st = FRAGCOORD.xy / u_resolution;
	//vec2 st = SCREEN_UV;
	//COLOR = vec4(st.x + u_mouse.x, st.y, 0.0, 1.0);
	vec2 mouse_norm = u_mouse / u_resolution;
	COLOR = vec4(st.x * mouse_norm.x, st.y * mouse_norm.y, 0.0, 1.0);	
}
