/// @description Bookshelf Init Event
// Initalizes the Books on the Bookshelf

// Inherit the parent event
event_inherited();

// Create Books
var temp_books_struct = 
{
	sub_layer_name: other.sub_layer_name,
	sub_layer_use_default_layer: other.sub_layer_use_default_layer
};

books = instance_create_depth
(
	x, 
	y, 
	depth,
	oEnvironment_AdobeHouse_Dynamic_Books,
	temp_books_struct
);

var temp_special_book_struct =
{
	sub_layer_name: other.sub_layer_name,
	sub_layer_use_default_layer: other.sub_layer_use_default_layer
};

special_book = instance_create_depth
(
	x - (14 * sign(image_xscale)), 
	y - (39 * sign(image_yscale)), 
	depth,
	oEnvironment_AdobeHouse_Dynamic_SpecialBook,
	temp_special_book_struct
);
