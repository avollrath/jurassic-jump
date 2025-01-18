shader_type canvas_item;

uniform float blur_strength : hint_range(1.0, 10.0) = 1.0;  // Controls blur intensity
uniform float darkness : hint_range(0.0, 1.0) = 0.8;  // Controls darkness (1 = no darkening, 0 = completely black)

void fragment() {
    vec4 col = texture(TEXTURE, UV) * 0.16;

    // Horizontal blur
    col += texture(TEXTURE, UV + vec2(TEXTURE_PIXEL_SIZE.x * blur_strength, 0.0)) * 0.075;
    col += texture(TEXTURE, UV + vec2(-TEXTURE_PIXEL_SIZE.x * blur_strength, 0.0)) * 0.075;
    col += texture(TEXTURE, UV + vec2(2.0 * TEXTURE_PIXEL_SIZE.x * blur_strength, 0.0)) * 0.06;
    col += texture(TEXTURE, UV + vec2(2.0 * -TEXTURE_PIXEL_SIZE.x * blur_strength, 0.0)) * 0.06;
    col += texture(TEXTURE, UV + vec2(3.0 * TEXTURE_PIXEL_SIZE.x * blur_strength, 0.0)) * 0.045;
    col += texture(TEXTURE, UV + vec2(3.0 * -TEXTURE_PIXEL_SIZE.x * blur_strength, 0.0)) * 0.045;
    col += texture(TEXTURE, UV + vec2(4.0 * TEXTURE_PIXEL_SIZE.x * blur_strength, 0.0)) * 0.025;
    col += texture(TEXTURE, UV + vec2(4.0 * -TEXTURE_PIXEL_SIZE.x * blur_strength, 0.0)) * 0.025;

    // Vertical blur
    col += texture(TEXTURE, UV + vec2(0.0, TEXTURE_PIXEL_SIZE.y * blur_strength)) * 0.075;
    col += texture(TEXTURE, UV + vec2(0.0, -TEXTURE_PIXEL_SIZE.y * blur_strength)) * 0.075;
    col += texture(TEXTURE, UV + vec2(0.0, 2.0 * TEXTURE_PIXEL_SIZE.y * blur_strength)) * 0.06;
    col += texture(TEXTURE, UV + vec2(0.0, 2.0 * -TEXTURE_PIXEL_SIZE.y * blur_strength)) * 0.06;
    col += texture(TEXTURE, UV + vec2(0.0, 3.0 * TEXTURE_PIXEL_SIZE.y * blur_strength)) * 0.045;
    col += texture(TEXTURE, UV + vec2(0.0, 3.0 * -TEXTURE_PIXEL_SIZE.y)) * 0.045;
    col += texture(TEXTURE, UV + vec2(0.0, 4.0 * TEXTURE_PIXEL_SIZE.y * blur_strength)) * 0.025;
    col += texture(TEXTURE, UV + vec2(0.0, 4.0 * -TEXTURE_PIXEL_SIZE.y)) * 0.025;

    // Apply darkness
    col.rgb *= darkness;

    COLOR = col;
}
