#version 150
// Original code: https://github.com/ShockMicro/VanillaDynamicEmissives

// Checks if the face should have lighting
bool face_lighting_check(int inputAlpha) {
    if (inputAlpha == 252) return false; // Checks for alpha 252, and returns that this face should not be lit
    if (inputAlpha == 250) return false; // Used in the example pack for lime concrete
    return true; // A face should be lit by default
}

// Makes sure transparent things don't become solid and vice versa
float remap_alpha(int inputAlpha) {
    if (inputAlpha == 252) return 255.0; // Checks for alpha 252 and converts all pixels of that to alpha 255
    if (inputAlpha == 251) return 190.0; // Make any transparent block work with this pack, the value can be changed
    if (inputAlpha == 250) return 255.0; // Used in the example pack for lime concrete
    return inputAlpha; // If a pixel doesn't need to have its alpha changed then it simply does not change
}

// The meat and bones of the pack, does all the work for making things emissive
vec4 make_emissive(vec4 inputColor, vec4 lightColor, vec4 faceLightColor, int inputAlpha) {
    // Windshields should not be emissive (not sure how useful this is)
    if (inputColor.r == 0.0 && inputColor.g == 0.0 && inputColor.b == 0.0) {
        return inputColor * lightColor;
    }

    // Applies the face lighting if the face should be lit
    if (face_lighting_check(inputAlpha)) inputColor *= faceLightColor;

    // Remap the alpha value
    inputColor.a = remap_alpha(inputAlpha) / 255.0;

    // Checks for alpha and just returns the input color, if it is
    if (inputAlpha != 255) return inputColor;

    // If none of the pixels are supposed to be emissive, then it adds the light
    return inputColor * lightColor;
}