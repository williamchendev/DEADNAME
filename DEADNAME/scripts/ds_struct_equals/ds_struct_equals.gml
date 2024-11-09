/// @function		ds_struct_equals(var1, var2);
/// @param			{struct}	var1
/// @param			{struct}	var2
/// @description	Compares the contents of two structs and returns `true` or `false` depending
///					on whether the contents and their values are equal. This script will function
///					recursively, also comparing any structs and arrays within the root struct.
///
///					Note that volatile data structure and method contents cannot be compared due
///					to GameMaker's handling of references for these types, and as such may behave
///					differently than expected:
///
///					Data structures will be compared by reference only and thus will only return
///					`true` if the exact same structure is referenced. Identical copies will 
///					return `false` because each copy has a unique (non-matching) index.
///
///					Methods cannot be compared by contents OR reference and therefore will always
///					return `true` provided a method exists at the same location in each struct.
///
/// @example		var struct1 = { name: "John Doe", age: 30 };
///					var struct2 = { age: 30, name: "John Doe" };
///
///					if (ds_struct_equals(struct1, struct2)) {
///						show_message("Structs are equal!");
///					}
///					
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

function ds_struct_equals(_a, _b) {
	// Skip if either struct doesn't exist
	if ((!is_struct(_a)) or (!is_struct(_b))) {
		return false;
	}
	
	// Get first level struct data
	var a_key, b_key, keys = variable_struct_get_names(_a),
		a_root = _a,
		b_root = _b;
	
	// Recursively get other levels
	for (var k = 0; k < array_length(keys); k++) {
		// Set root
		if (!is_string(keys[k])) {
			a_root = keys[k];
			b_root = keys[k + 1];
			k++;
		} else {
			// Get current keys
			if (is_array(a_root)) {
				a_key = a_root[real(keys[k])];
				b_key = b_root[real(keys[k])];
			} else {
				a_key = variable_struct_get(a_root, keys[k]);
				b_key = variable_struct_get(b_root, keys[k]);
				
				// Otherwise return `false` if matching key not found
				if (is_undefined(b_key)) {
					return false;
				}
			}
			
			// Recurse structs
			if (is_struct(a_key)) {
				if (is_struct(b_key)) {
					if (variable_struct_names_count(a_key) == variable_struct_names_count(b_key)) {
						array_push(keys, a_key);
						array_push(keys, b_key);
						array_copy(
							keys, array_length(keys), 
							variable_struct_get_names(a_key), 0, variable_struct_names_count(a_key)
						);
					} else {
						// Otherwise return `false` if structs do not match
						return false;
					}
				} else {
					// Otherwise return `false` if matching struct not found
					return false;
				}
				continue;
			}
			
			// Recurse arrays
			if (is_array(a_key)) {
				if (is_array(b_key)) {
					if (array_length(a_key) == array_length(b_key)) {
						array_push(keys, a_key);
						array_push(keys, b_key);
						for (var i = 0; i < array_length(a_key); i++) {
							array_push(keys, string(i));
						}
					} else {
						// Otherwise return `false` if arrays do not match
						return false;
					}
				} else {
					// Otherwise return `false` if matching array not found
					return false;
				}
				continue;
			}
			
			// Compare methods
			if (is_method(a_key)) {
				if (!is_method(b_key)) {
					// Otherwise return `false` if matching method not found
					return false;
				}
				continue; // (Cannot check if method contents match)
			}
			
			// Compare keys
			if (a_key != b_key) {
				// Otherwise return `false` if keys do not match
				return false;
			}
		}
	}
	
	// Return `true` if no content was unequal
	return true;
}