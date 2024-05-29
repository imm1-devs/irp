#version 150

#moj_import <fog.glsl>
#moj_import <emissive_utils.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec2 texCoord0;
in vec4 vertexColor;

out vec4 fragColor;

void main() {
    // Vanilla behavior
    vec4 color = texture(Sampler0, texCoord0);
    if (color.a < 0.1) {
        discard;
    }
    fragColor = linear_fog(color * vertexColor * ColorModulator, vertexDistance, FogStart, FogEnd, FogColor);

    // Discarding ugly black particles stuck inside blocks
    if (vertexColor.r < 0.1 && vertexColor.g < 0.1 && vertexColor.b < 0.1) {
        discard;
    }

    // Transparent particles become emissive
    // (ignoring glass particles though)
    if (color.a < 0.99 && color.a > 0.9) {
		fragColor = color;
    }
}
