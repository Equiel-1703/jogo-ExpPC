shader_type canvas_item;

uniform vec3 desired_color;

// Color white
const vec4 WHITE = vec4(1,1,1,1);

float findMax(float num1, float num2, float num3) {
    float max = num1; // Assume num1 is the greatest initially
    
    if (num2 > max) {
        max = num2;
    }
    if (num3 > max) {
        max = num3;
    }
    
    return max;
}

float findMin(float a, float b, float c) {
    // Assume 'a' is the smallest initially
    float smallest = a;
    
    // Compare 'smallest' with 'b' and update if 'b' is smaller
    if (b < smallest) {
        smallest = b;
    }
    
    // Compare 'smallest' with 'c' and update if 'c' is smaller
    if (c < smallest) {
        smallest = c;
    }
    
    return smallest;
}

// Function to calculate the luminance of an RGB color
float calculateLuminance(vec3 rgb) {
    return 0.2126 * rgb.r + 0.7152 * rgb.g + 0.0722 * rgb.b;
}

// Function to adjust the RGB of a color to match a target luminance
vec3 adjustBrightness(vec3 rgb, float targetLuminance) {
    float currentLuminance = calculateLuminance(rgb);
    float ratio = targetLuminance / currentLuminance;

    // Scale the RGB values
    return rgb *= ratio;
}

void fragment() {
	if (COLOR != WHITE) {
		float r, g, b;
		
		r = COLOR.r;
		g = COLOR.g;
		b = COLOR.b;
		
		vec3 current_color = vec3(r,g,b);
		
		//float vmax = findMax(r,g,b);
		//float vmin = findMin(r,g,b);
		//
		//float l = (vmax + vmin) / 2.0;
		//
		//COLOR = vec4(l,l,l, COLOR.a);
		
		current_color = adjustBrightness(desired_color, calculateLuminance(current_color));
		
		COLOR = vec4(current_color, COLOR.a);
	}
}
