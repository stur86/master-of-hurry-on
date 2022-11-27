shader_type canvas_item;

uniform float tfac = 2.0;

void fragment() {
	// Place fragment code here
	vec2 xy = SCREEN_UV/SCREEN_PIXEL_SIZE;
	float s = xy.x+xy.y;
	float a_s = floor(mod(s, tfac)/(tfac-1.0));
	float r = length(UV-vec2(.5, .5))*2.0;
	COLOR = vec4(0.0, 1.0, 0.4, r < 1.0? a_s: 0.0);
}
