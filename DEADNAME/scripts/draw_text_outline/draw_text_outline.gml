/// @function draw_text_outline(x_pos, y_pos, text, text_color, outline_color);
/// @description Draws text at the given position, with the given text color and outline color.  It really doesn't get more simple than this
/// @param {real} x_pos - The x coordinate position to draw the given text
/// @param {real} y_pos - The y coordinate position to draw the given text
/// @param {string} text - The text to draw as a string
/// @param {int} text_color - The color to draw the text as
/// @param {int} outline_color - The color to draw the text's outline as
function draw_text_outline(x_pos, y_pos, text, text_color = c_white, outline_color = c_black)
{
	draw_set_colour(outline_color);
    draw_text(x_pos - 1, y_pos, text);
    draw_text(x_pos + 1, y_pos, text);
    draw_text(x_pos, y_pos - 1, text);
    draw_text(x_pos, y_pos + 1, text);
	
    draw_set_colour(text_color);
    draw_text(x_pos, y_pos, text);
}
