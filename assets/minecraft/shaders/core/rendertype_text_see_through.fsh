#version 150

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;

in vec4 vertexColor;
in vec2 texCoord0;

out vec4 fragColor;

void main() {
    if (fragColor.a == 0.0) {
        discard; // no name tag
    }
    fragColor = vertexColor;
}
