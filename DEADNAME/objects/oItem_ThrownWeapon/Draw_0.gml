/// @description Thrown Weapon Fuze Timer Draw Event
// Draw Thrown Weapon's Fuze Timer to UI Surface

// Draw Throwable Weapon Fuze Timer
if (!show_ui_fuze_timer)
{
	return;
}

// Check if Thrown Weapon has an Weapon Instance
if (item_instance == noone)
{
	return;
}

// Check if Thrown Weapon's Fuze Timer is Active
if (is_undefined(item_instance.thrown_weapon_fuze_timer))
{
	return;
}

// Draw to UI Surface
surface_set_target(LightingEngine.ui_surface);

// Cursor GUI Behaviour
draw_set_alpha(1);
draw_set_color(c_white);
	
// Create Throwable Weapon Fuze Timer's Text
var temp_thrown_weapon_fuze_timer_display_text = string_delete(string(item_instance.thrown_weapon_fuze_timer), -1, -1);
					
// Set Throwable Weapon Fuze Timer Text Font
draw_set_font(font_Default);
					
// Set Throwable Weapon Fuze Timer Text Alignment
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
					
// Draw Throwable Weapon Fuze Timer's Text
draw_text_outline(phy_position_x - LightingEngine.render_x, phy_position_y - LightingEngine.render_y - (sprite_height * 0.5), $"{temp_thrown_weapon_fuze_timer_display_text}s");
	
// Reset Surface
surface_reset_target();
