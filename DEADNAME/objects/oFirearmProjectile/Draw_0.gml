/// @description Firearm Projectile Draw Event
// Draws the Firearm Projectile to the Screen

// Draw Bullet Trail
var temp_trail_x = x;
var temp_trail_y = y;
for (var i = ds_list_size(bullet_trail_list) - 1; i >= 0; i--) {
	var temp_trail_direction = ds_list_find_value(bullet_trail_list, i);
	temp_trail_x += lengthdir_x(-1, temp_trail_direction);
	temp_trail_y += lengthdir_y(-1, temp_trail_direction);
	draw_sprite_ext(sprite_index, image_index, temp_trail_x, temp_trail_y, image_xscale, image_yscale, temp_trail_direction, image_blend, (i / ds_list_size(bullet_trail_list)) * bullet_trail_alpha);
}

// Draw Bullet
draw_self();