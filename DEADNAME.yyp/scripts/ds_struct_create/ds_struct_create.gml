/// @function		ds_struct_create();
/// @description	Creates a new struct and returns the index (or ID).
///	
///					A **struct** is a data structure similar to JSON (and also to GameMaker objects
///					themselves!). Sometimes dubbed "lightweight objects", a struct contains a tree of 
///					key/value pairs which can themselves contain other structs, methods, or any other 
///					data type.
///	
///					Like a ds_map, struct data is unordered. However, unlike *any other data structure*,
///					structs are inherently non-scoped and non-volatile. This means any instance can 
///					access the struct by its ID without the need for copying the entire struct from one
///					instance to another. Furthermore, instance variables like `x` and `y` can be given  
///					their own independent definitions within a struct. 
///	
///					Once created, a struct incurs no processing overhead and will exist until destroyed
///					manually or until no more references to it exist, at which point it will be purged
///					automatically. In other words, unlike other data structures, structs will typically
///					not memory leak.
///	
///					With so many positives, it's important to keep one negative in mind: structs are 
///					ideal for data with *static, pre-determined trees*. This means you should always
///					know where data is stored in the struct rather than locate it programatically.
///					While GML+ provides functions to do just that, they are potentially quite slow and
///					should be used sparingly. For highly dynamic data, other data structures remain
///					preferable.
///
/// @example		my_struct = ds_struct_create();
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved
	
function ds_struct_create() {
	// Create a new struct and return the index
	return {};
}