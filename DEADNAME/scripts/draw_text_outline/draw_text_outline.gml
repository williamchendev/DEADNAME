// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function draw_text_outline(x_pos, y_pos, text, text_color, outline_color)
{
	draw_set_colour(outline_color);
    draw_text(x_pos - 1, y_pos - 1, text);
    draw_text(x_pos - 1, y_pos + 1, text);
    draw_text(x_pos + 1, y_pos + 1, text);
    draw_text(x_pos + 1, y_pos - 1, text);
	
    draw_set_colour(text_color);
    draw_text(x_pos, y_pos, text);
}