#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:fog.glsl>
#include <minecraft:dynamictransforms.glsl>
#include <minecraft:oit.glsl>

uniform sampler2D Sampler0;

layout(location = 0) in float sphericalVertexDistance;
layout(location = 1) in float cylindricalVertexDistance;
layout(location = 2) in vec2 texCoord0;
layout(location = 3) in vec4 vertexColor;

#ifndef OIT_ALPHA_ONLY
layout(location = 0) out vec4 fragColor;
#endif

vec4 calculateFinalColor(vec4 color) {
    #ifdef OIT_ACCUMULATE
    color = sampleColorForAccumulation(color);
    vec4 fogColor = vec4(FogColor.rgb * color.a, FogColor.a);
    #else
    vec4 fogColor = FogColor;
    #endif
    return apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, fogColor);
}

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

    // Transparent particles become emissive (ignoring glass particles though)
    // Note: this early-return bypasses OIT and fog. In OIT_ALPHA_ONLY pass this
    // would skip executeAlphaOnlyPhase, so we only do it when NOT in alpha-only pass.
    #ifndef OIT_ALPHA_ONLY
    if (color.a < 1.0 && color.a > 0.9) {
        fragColor = color;
        return;
    }
    #endif

    // VANILLA BEHAVIOR START
    vec4 finalColor = color * vertexColor * ColorModulator;

    #ifdef OIT_ALPHA_ONLY
    executeAlphaOnlyPhase(gl_FragCoord.z, finalColor.a);
    #else
    fragColor = calculateFinalColor(finalColor);
    #endif
    // VANILLA BEHAVIOR END
}