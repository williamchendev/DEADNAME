/// @function		color_get_hex(color);
/// @param			{color}	color
/// @description	Returns a hex color code from an RGB color, as a string.
///				
///					Note that a leading # is returned along with the color string. If any  
///					unacceptable input is made, the script will return "#FFFFFF".
///
/// @example		color = color_get_hex(c_red);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function color_get_hex(_color) {
	// Error prevention - in the event of mal-formed input, return white and exit the script
	if (is_string(_color)) { // Ensure input is a color code
		return "#FFFFFF";
	}

	// Initialize temporary variables for calculating hex color
	var r1, r2, g1, g2, b1, b2, r, g, b;

	// Get individual color values from input color
	r = color_get_red(_color);
	g = color_get_green(_color);
	b = color_get_blue(_color);

	// Separate channels to 16-bit values
	r1 = r div 16;
	r2 = r - (r1*16);

	g1 = g div 16;
	g2 = g - (g1*16);

	b1 = b div 16;
	b2 = b - (b1*16);

	// Convert the separated rgb values into hex strings
	switch (r1) {
		case 10: r1 = "A"; break;
		case 11: r1 = "B"; break;
		case 12: r1 = "C"; break;
		case 13: r1 = "D"; break;
		case 14: r1 = "E"; break;
		case 15: r1 = "F"; break;
		default: r1 = string(r1);
	}

	switch (r2) {
		case 10: r2 = "A"; break;
		case 11: r2 = "B"; break;
		case 12: r2 = "C"; break;
		case 13: r2 = "D"; break;
		case 14: r2 = "E"; break;
		case 15: r2 = "F"; break;
		default: r2 = string(r2);
	}

	switch (g1) {
		case 10: g1 = "A"; break;
		case 11: g1 = "B"; break;
		case 12: g1 = "C"; break;
		case 13: g1 = "D"; break;
		case 14: g1 = "E"; break;
		case 15: g1 = "F"; break;
		default: g1 = string(g1);
	}

	switch (g2) {
		case 10: g2 = "A"; break;
		case 11: g2 = "B"; break;
		case 12: g2 = "C"; break;
		case 13: g2 = "D"; break;
		case 14: g2 = "E"; break;
		case 15: g2 = "F"; break;
		default: g2 = string(g2);
	}

	switch (b1) {
		case 10: b1 = "A"; break;
		case 11: b1 = "B"; break;
		case 12: b1 = "C"; break;
		case 13: b1 = "D"; break;
		case 14: b1 = "E"; break;
		case 15: b1 = "F"; break;
		default: b1 = string(b1);
	}

	switch (b2) {
		case 10: b2 = "A"; break;
		case 11: b2 = "B"; break;
		case 12: b2 = "C"; break;
		case 13: b2 = "D"; break;
		case 14: b2 = "E"; break;
		case 15: b2 = "F"; break;
		default: b2 = string(b2);
	}

	// Return the color
	return "#" + r1 + r2 + g1 + g2 + b1 + b2;
}
