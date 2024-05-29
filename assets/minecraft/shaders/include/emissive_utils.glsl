#version 150
// Original code: https://github.com/ShockMicro/VanillaDynamicEmissives


// Checks if the face should have lighting.
bool face_lighting_check(int inputAlpha) {
    if (inputAlpha == 252) return false; // Checks for alpha 252, and returns that this face should not be lit. Used in the example pack for redstone ore and the zombie's eyes.
    if (inputAlpha == 250) return false; // Used in the example pack for lime concrete.
    return true; // A face should be lit by default
}


// Makes sure transparent things don't become solid and vice versa.
float remap_alpha(int inputAlpha) {
    if (inputAlpha == 252) return 255.0; // Checks for alpha 252 and converts all pixels of that to alpha 255. Used in the example pack for redstone ore and the zombie's eyes.
    if (inputAlpha == 251) return 190.0; // You can copy & paste this line and change the values to make any transparent block work with this pack. Used in the example pack for ice.
    if (inputAlpha == 250) return 255.0; // Used in the example pack for lime concrete.
    return inputAlpha; // If a pixel doesn't need to have its alpha changed then it simply does not change.
}


// The meat and bones of the pack, does all the work for making things emissive.
vec4 make_emissive(vec4 inputColor, vec4 lightColor, vec4 faceLightColor, int inputAlpha) {
    if (face_lighting_check(inputAlpha)) inputColor *= faceLightColor; // Applies the face lighting if the face should be lit
    inputColor.a = remap_alpha(inputAlpha) / 255.0; // Remap the alpha value
    if (inputAlpha != 255) return inputColor; // Checks for alpha and just returns the input color if it is.
    return inputColor * lightColor; // If none of the pixels are supposed to be emissive, then it adds the light.
}