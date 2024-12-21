
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
        var temp_uvs = sprite_get_uvs_transformed(sprite_a, i, sprite_b, i);
        
        //
        temp_spritepack_struct.uv_buffers[i] = buffer_create(4 * buffer_sizeof(buffer_f32), buffer_fixed, 1);
        
        buffer_write(temp_spritepack_struct.uv_buffers[i], buffer_f32, temp_uvs[0]);
        buffer_write(temp_spritepack_struct.uv_buffers[i], buffer_f32, temp_uvs[1]);
        buffer_write(temp_spritepack_struct.uv_buffers[i], buffer_f32, temp_uvs[2]);
        buffer_write(temp_spritepack_struct.uv_buffers[i], buffer_f32, temp_uvs[3]);
        
        //
        temp_spritepack_struct.textures[i] = sprite_get_texture(sprite_b, i);
        
        //
        i++;
    }
    
    return temp_spritepack_struct;
}