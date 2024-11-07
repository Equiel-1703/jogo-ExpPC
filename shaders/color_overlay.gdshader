shader_type canvas_item;

uniform vec3 color_rgb = vec3(0,0,0);

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = vec4(color_rgb, COLOR.a);
}