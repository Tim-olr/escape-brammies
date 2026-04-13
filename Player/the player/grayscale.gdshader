shader_type canvas_item;

uniform float shake: hint_range(0, 10) = 0.015;
uniform float noiseQuality: hint_range(0.1, 250, 0.1) = 250;
uniform float noiseIntensity: hint_range(0, 0.05, 0.001) = 0.001;
uniform float offsetIntensity: hint_range(0, 0.05, 0.0001) = 0.0045;
uniform float colorOffsetIntensity: hint_range(0.1, 1.5, 0.001) = 0.2;
uniform float pixelSize: hint_range(1, 1024) = 200.0;
uniform float grainIntensity: hint_range(0, 1) = 0.04;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D overlay_texture : hint_default_transparent;
uniform bool use_overlay = true;
uniform bool use_lens_distortion = true;
uniform vec4 overlay_color : source_color = vec4(1.0, 1.0, 1.0, 10.0);
uniform float lens_distortion_strength: hint_range(0, 0.1) = 0.05;
uniform float saturation: hint_range(0.0, 1.0) = 1.0; // 0 = grayscale, 1 = full color

varying vec2 previous_pos;

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float verticalBar(float pos, float uvY, float offset) {
    float edge0 = (pos - shake);
    float edge1 = (pos + shake);
    float x = smoothstep(edge0, pos, uvY) * offset;
    x -= smoothstep(pos, edge1, uvY) * offset;
    return x;
}

void fragment() {
    vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 uv = FRAGCOORD.xy / iResolution.xy;

    vec2 velocity = uv - previous_pos;

    // Pixelation
    uv = floor(uv * pixelSize) / pixelSize;

    // Vertical bars distortion
    for (float i = 0.0; i < 0.71; i += 0.1313) {
        float d = mod(TIME * i, 1.7);
        float o = sin(1.0 - tan(TIME * 0.24 * i));
        o *= offsetIntensity;
        uv.x += verticalBar(d, uv.y, o);
    }

    // Noise distortion
    float uvY = uv.y * noiseQuality;
    uvY = float(int(uvY)) * (1.0 / noiseQuality);
    float noise = rand(vec2(TIME * 0.00001, uvY));
    uv.x += noise * noiseIntensity;

    // Color channel offset
    vec2 offsetR = vec2(0.006 * sin(TIME), 0.0) * colorOffsetIntensity;
    vec2 offsetG = vec2(0.0073 * cos(TIME * 0.97), 0.0) * colorOffsetIntensity;
    float r = texture(screen_texture, uv + offsetR).r;
    float g = texture(screen_texture, uv + offsetG).g;
    float b = texture(screen_texture, uv).b;
    vec4 tex = vec4(r, g, b, 1.0);

    // Overlay
    if (use_overlay) {
        vec4 overlayColor = texture(overlay_texture, uv) * overlay_color;
        tex = mix(tex, overlayColor, overlayColor.a);
    }

    // Film grain
    float grain = rand(uv) * 2.0 - 1.0;
    tex.rgb += grainIntensity * grain;

    // Lens distortion
    if (use_lens_distortion) {
        vec2 distortion = uv * lens_distortion_strength * (uv - 1.0);
        vec4 distorted_tex = texture(screen_texture, uv + distortion);
        tex = mix(tex, distorted_tex, 0.5);
    }

    // Saturation
    float gray = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
    tex.rgb = mix(vec3(gray), tex.rgb, saturation);

    COLOR = tex;

    previous_pos = FRAGCOORD.xy / iResolution.xy;
}