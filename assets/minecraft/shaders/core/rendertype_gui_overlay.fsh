#version 150

in vec4 vertexColor;

uniform vec4 ColorModulator;

out vec4 fragColor;

void main() {
    vec4 color = vertexColor;
    if (color.a == 0.0) {
        discard;
    }

    if (color.r == color.g && color.g == color.b && color.b == 1.0) {
        discard; // no item slot highlighting
    }

    fragColor = color * ColorModulator;
}
