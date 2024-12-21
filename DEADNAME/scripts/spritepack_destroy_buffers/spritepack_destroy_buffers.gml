function spritepack_destroy_buffers(spritepack_buffers) 
{
    for (var i = array_length(spritepack_buffers) - 1; i >= 0; i--)
    {
        buffer_delete(spritepack_buffers[i]);
    }
}