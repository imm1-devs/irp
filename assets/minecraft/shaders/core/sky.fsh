#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:fog.glsl>
#include <minecraft:dynamictransforms.glsl>

layout(location = 0) in float sphericalVertexDistance;
layout(location = 1) in float cylindricalVertexDistance;

layout(location = 0) out vec4 fragColor;

void main() {
    vec4 sky = ColorModulator * 0.8;
    fragColor = apply_fog(sky,
            sphericalVertexDistance,
            cylindricalVertexDistance,
            0.0,
            FogSkyEnd,
            FogSkyEnd,
            FogSkyEnd,
            FogColor);
}
