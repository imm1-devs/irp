#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

in float sphericalVertexDistance;
in float cylindricalVertexDistance;

out vec4 fragColor;

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
