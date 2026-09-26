shader_type canvas_item;

uniform vec4 target_color : source_color = vec4(1.0, 0.45, 0.05, 1.0);

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	float max_channel = max(tex.r, max(tex.g, tex.b));
	float min_channel = min(tex.r, min(tex.g, tex.b));
	float saturation = max_channel - min_channel;

	float blue_amount = smoothstep(0.05, 0.35, tex.b - tex.r);
	blue_amount *= smoothstep(0.03, 0.20, saturation);

	float brightness = max_channel;

	vec3 recolored = target_color.rgb * brightness;
	vec3 final_color = mix(tex.rgb, recolored, blue_amount);

	COLOR = vec4(final_color, tex.a);
}