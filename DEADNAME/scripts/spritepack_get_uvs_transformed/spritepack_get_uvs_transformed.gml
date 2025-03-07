/// @function spritepack_get_uvs_transformed(sprite_a, sprite_b);
/// @description Creates a SpritePack array of structs containing transformed UVs and texture indexes to draw using the Deferred Lighting Engine's Multi-Render-Target Workflow coresponding to the two given sprite index assets as arguments
/// @param {sprite} sprite_a - The First Sprite with unchanged texture coordinates to map the Second Sprite's transformed UVs on to
/// @param {sprite} sprite_b - The Second Sprite whose transformed UVs will be mapped over the First Sprite's texture coordinates
/// @returns {array<struct>} Returns a SpritePack array of structs containing transformed UVs (return_variable[subimage_index].uvs) and texture indexes (return_variable[subimage_index].texture) to map the Second Sprite over the First Sprite when using MRT Shaders
function spritepack_get_uvs_transformed(sprite_a, sprite_b) 
{
	// Set SpritePack array as null
	var temp_spritepack = -1;
	
	// Iterate through every subimage of the First Sprite
    for(var i = 0; i < sprite_get_number(sprite_a); i++)
    {
    	// Index Transformed UVs and Texture Index Struct to SpritePack
        temp_spritepack[i] = { uvs: sprite_get_uvs_transformed(sprite_a, i, sprite_b, i), texture: sprite_get_texture(sprite_b, i) };
    }
    
    // Return SpritePack array
    return temp_spritepack;
}
