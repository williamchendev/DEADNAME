
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