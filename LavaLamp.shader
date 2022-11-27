shader_type canvas_item;

uniform float threshold = 0.3;
uniform float color_edge = 1.9;
uniform float glow_power = 7.0;
uniform float max_strength = 16.0;
uniform float top = 0.2;
uniform float bottom = 0.6;
uniform vec4 background_edge: hint_color;
uniform vec4 background_center: hint_color;
uniform vec4 blob_top: hint_color;
uniform vec4 blob_bottom: hint_color;


float oscillate(float x, float speed, float offset) {
	return pow(sin(x * speed + offset), 2) * (bottom - top) + top;
}
void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (COLOR == vec4(1.0, 0.0, 1.0, 1.0)) {
		COLOR = mix(background_center, background_edge, abs(0.5 - UV.x) * color_edge);
		
		vec3 blob_centers[] =
		{
			vec3(0.6, oscillate(TIME, 0.5, 0.4), 0.5),
			vec3(0.5, oscillate(TIME, 0.2, 0.5), 0.6),
			vec3(0.55, oscillate(TIME, 0.1, 0.1), 0.5),
			vec3(0.45, oscillate(TIME, 0.1, 0.2), 0.6),
			vec3(0.62, oscillate(TIME, 0.1, 0.0), 0.8),
			vec3(0.7, oscillate(TIME, 0.2, 1.9), 0.6)
		};
		float influence = 0.0;
		for (int i = 0; i < blob_centers.length(); i++) {
			float distance_to_blob_center = distance(blob_centers[i].xy / TEXTURE_PIXEL_SIZE, UV / TEXTURE_PIXEL_SIZE);
			influence += blob_centers[i].z * max_strength * (1.0 / distance_to_blob_center);
		}
		vec4 current_blob_color = mix(blob_top, blob_bottom, (UV.y - top) / (bottom - top));
		float glow_mult = threshold * 10.0;
		COLOR = mix(COLOR, current_blob_color, pow(glow_mult * influence, glow_power));
		if (influence > threshold) {
			COLOR = current_blob_color;
		}
	}
}