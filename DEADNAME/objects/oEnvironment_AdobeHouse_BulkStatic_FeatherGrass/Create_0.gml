/// @description Random Frame Select
// Sets the Subimage of this Feather Grass to a random index

image_index = random_range(0, sprite_get_number(sprite_index) - 1);
image_xscale = random_range(-1, 1) > 0 ? 1 : -1;
