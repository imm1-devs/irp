#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec2 texCoord0;
in vec4 vertexColor;

out vec4 fragColor;

void main() {
    // VANILLA BEHAVIOR START
    vec4 color = texture(Sampler0, texCoord0);
    if (color.a < 0.1) {
        discard;
    }
    // VANILLA BEHAVIOR END

    // Discarding ugly black particles stuck inside blocks
    if (vertexColor.r < 0.1 && vertexColor.g < 0.1 && vertexColor.b < 0.1) {
        discard;
    }

    // Transparent particles become emissive
    // (ignoring glass particles though)
    if (color.a < 1.0 && color.a > 0.9) {
		fragColor = color;
        return;
    }

    // VANILLA BEHAVIOR START
    fragColor = apply_fog(color * vertexColor * ColorModulator,
            sphericalVertexDistance,
            cylindricalVertexDistance,
            FogEnvironmentalStart,
            FogEnvironmentalEnd,
            FogRenderDistanceStart,
            FogRenderDistanceEnd,
            FogColor);
    // VANILLA BEHAVIOR END
}