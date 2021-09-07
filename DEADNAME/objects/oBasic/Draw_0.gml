/// @description Basic Light Object Draw
// Performs the Draw Event and Behaviour of the Basic Lighting Object

// Basic Normal/Lit Sprite Split
if (lit_draw_event) {
	sprite_index = lit_sprite_index;
}
else if (normal_draw_event) {
	sprite_index = normal_sprite_index;
}
else {
	return;
}

// Basic Draw Behaviour
draw_self();