
function spritepack_get_uvs_transformed(sprite_a, sprite_b) 
{
    //
    var temp_spritepack_struct =
    {
        textures: -1,
        uv_buffers: -1
    }
    
    //
    var i = 0;
    
    repeat(sprite_get_number(sprite_a))
    {
        //
        temp_spritepack_struct.uvs[i] = sprite_get_uvs_transformed(sprite_a, i, sprite_b, i);
        
        //
        temp_spritepack_struct.textures[i] = sprite_get_texture(sprite_b, i);
        
        //
        i++;
    }
    
    return temp_spritepack_struct;
}