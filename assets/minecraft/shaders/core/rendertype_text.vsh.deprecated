#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;
uniform vec2 ScreenSize; // for xp numbers removal to work

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

bool isAt(int offset, int vID, int pos) {
    return (((vID == 1 || vID == 2) && offset == pos) || ((vID == 0 || vID == 3) && offset == (pos + 8)));
}

bool title_shadows() {
    float r = Color.xyz[0];
    float g = Color.xyz[1];
    float b = Color.xyz[2];
    if (r == g && g == b
            && r > 0.1 && g > 0.1 && b > 0.1
            && r < 0.3 && g < 0.3 && b < 0.3) {
        gl_Position = vec4(2, 2, 2, 1);
        return true;
    }
    return false;
}

void xp_number() {
    // get the size of a text pixel
    vec2 pixel = vec2(ProjMat[0][0], ProjMat[1][1]) / 2.0;

    // get the gui scale
    int guiScale = int(round(pixel.x / (1 / ScreenSize.x)));

    // get the size of the gui space
    vec2 guiSize = ScreenSize / guiScale;

    // get the vertex id for each specific character
    int vID = gl_VertexID % 4;

    // get the offset from the bottom 
    int offset = int(round(guiSize.y - Position.y));

    // offset xp text
    // the bright text starts 27 pixels from the bottom, sometimes at 26
    if (((length(Color.rgb - vec3(0.501, 1.0, 0.125)) < 0.002 && (isAt(offset, vID, 26) || isAt(offset, vID, 27)))
            || (length(Color.rgb - vec3(0.0, 0.0, 0.0)) < 0.002 && (isAt(offset, vID, 25) || isAt(offset, vID, 26) || isAt(offset, vID, 27) || isAt(offset, vID, 28))))) {
            // the darker background consists out of 3 elements (26, 27, 28), sometimes (25, 26, 27)

        // Reposition
        vec3 pos = Position;
        pos += vec3(0.0, -3.0, 0.0); // apply an offset
        gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);
        // Reposition End

        // Recolor
        if (length(Color.rgb - vec3(0.0, 0.0, 0.0)) < 0.002) {
            vertexColor = vec4(0.0, 0.0, 0.0, 1); // shadow (usually black)
        } else {
            vertexColor = vec4(0.6, 0.8, 1.0, 1); // text (usually green)
        }
        // Recolor End
    }
}

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = fog_distance(Position, FogShape);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;

    // isolating from different text
    // it's 0 on 1.20.4, but 600 on 1.20.5 and above
    // mojangs are so stupid
    if (Position.z == 0.0 && title_shadows()) xp_number();
    if (Position.z == 2400.0) title_shadows();
    if (Position.z == 600.0) xp_number();
}