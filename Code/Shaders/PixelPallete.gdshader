shader_type canvas_item;

uniform float resolution: hint_range(0.0, 1000.0, 1.0) = 32.0;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = texture(SCREEN_TEXTURE, round(SCREEN_UV * (resolution + 1.0) - (UV - 0.5)) / (resolution + 1.0));
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
