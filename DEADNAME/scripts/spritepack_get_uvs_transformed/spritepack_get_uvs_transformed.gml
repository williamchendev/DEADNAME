function spritepack_get_uvs_transformed(sprite_a, sprite_b) 
{
	//
	var temp_spritepack = -1;
	
	//
    for(var i = 0; i < sprite_get_number(sprite_a); i++)
    {
        temp_spritepack[i] = { uvs: sprite_get_uvs_transformed(sprite_a, i, sprite_b, i), texture: sprite_get_texture(sprite_b, i) };
    }
    
    //
    return temp_spritepack;
}