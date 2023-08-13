shader_type canvas_item;
render_mode unshaded;

uniform bool red;
uniform bool blue;
uniform bool green;
uniform bool alpha;

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	vec4 col = original_color;
	if (red) col.r = 1.0 - col.r;
	if (green) col.g = 1.0 - col.g;
	if (blue) col.b = 1.0 - col.b;
	if (alpha) col.a = 1.0 - col.a;
	
	vec4 output = mix(original_color.rgba, col, original_color.a);
	COLOR = output;
	
}
