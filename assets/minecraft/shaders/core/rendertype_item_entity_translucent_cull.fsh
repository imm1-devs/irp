#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec2 texCoord1;

out vec4 fragColor;

vec4 calc_out(vec4 color) {
    return apply_fog(color * vertexColor * ColorModulator,
            sphericalVertexDistance,
            cylindricalVertexDistance,
            FogEnvironmentalStart,
            FogEnvironmentalEnd,
            FogRenderDistanceStart,
            FogRenderDistanceEnd,
            FogColor);
}

void main() {
    // VANILLA BEHAVIOR START
    vec4 color = texture(Sampler0, texCoord0);
    if (color.a < 0.1) {
        // Slimeballs
        if (color.a == 0.003921568627451 && color.g > color.r && color.g > color.b) {
            color.a = 1.0;
            fragColor = calc_out(color);
            return;
        }
        discard;
    }
    // VANILLA BEHAVIOR END

    // Glass
//  if (color.a == 0.4 || color.a == 0.6392156862745098 || color.a == 0.607843137254902) {
//      fragColor = calc_out(color);
//      return;
//  }

    if (color.a < 1.0) {
        fragColor = color;
        return;
    }

    fragColor = calc_out(color);
}
