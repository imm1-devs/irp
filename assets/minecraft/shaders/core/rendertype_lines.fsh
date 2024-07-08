#version 150

#moj_import <fog.glsl>

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;

out vec4 fragColor;

void main() {
    // Sick recolored block selection B-)
    if (vertexColor.r == vertexColor.g
     && vertexColor.g == vertexColor.b
     && vertexColor.b == 0.0
     && vertexColor.a < 0.5) { // isolating the debug-crosshair
        fragColor = vec4(1.0, 1.0, 1.0, 0.75); // the last argument is alpha
        return;
    }

    // Vanilla behavior
    vec4 color = vertexColor * ColorModulator;
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}