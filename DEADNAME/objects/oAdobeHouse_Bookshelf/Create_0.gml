/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

// Create Books on Shelf
var temp_books = instance_create_layer(x, y, layer, oAdobeHouse_Books);
temp_books.background_layer = background_layer;
temp_books.instance_layer = instance_layer;
temp_books.foreground_layer = foreground_layer;
temp_books.image_xscale = image_xscale;
temp_books.image_yscale = image_yscale;
temp_books.depth = depth - 1;

// Create Special Book on Shelf
var temp_books = instance_create_layer(x - (14 * sign(image_xscale)), y - (39 * sign(image_yscale)), layer, oAdobeHouse_SpecialBook);
temp_books.background_layer = background_layer;
temp_books.instance_layer = instance_layer;
temp_books.foreground_layer = foreground_layer;
temp_books.image_xscale = image_xscale;
temp_books.image_yscale = image_yscale;
temp_books.depth = depth - 2;