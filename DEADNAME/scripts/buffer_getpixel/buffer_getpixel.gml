// Generated at 2025-04-27 15:42:06 (274ms) for v2022.0.3+
/// @lint nullToAny true
// Feather disable all

#region buffer_getpixel

function buffer_getpixel_begin(_surface1, _buffer1) 
{
	/// buffer_getpixel_begin(surface:surface, ?buffer:buffer)->buffer?
	/// @param {surface} surface
	/// @param {buffer} ?buffer
	/// @returns {buffer?}
	if (false) show_debug_message(argument[1]);
	var _width = surface_get_width(_surface1);
	var _height = surface_get_height(_surface1);
	var _size = 8 + _width * _height * 4;
	if (_buffer1 == undefined) {
		_buffer1 = buffer_create(_size, buffer_fixed, 1);
	} else if (buffer_get_size(_buffer1) < _size) {
		buffer_resize(_buffer1, _size);
	}
	buffer_poke(_buffer1, 0, buffer_u32, _width);
	buffer_poke(_buffer1, 4, buffer_u32, _height);
	buffer_get_surface(_buffer1, _surface1, 8);
	return _buffer1;
}

function buffer_getpixel_ext(_buffer1, _x, _y) 
{
	/// buffer_getpixel_ext(buffer:buffer, x:int, y:int)->int
	/// @param {buffer} buffer
	/// @param {int} x
	/// @param {int} y
	/// @returns {int}
	gml_pragma("forceinline");
	var _width;
	_x &= $7FFFFFFF;
	_y &= $7FFFFFFF;
	_width = buffer_peek(_buffer1, 0, buffer_u32);
	if (_x >= _width || _y >= buffer_peek(_buffer1, 4, buffer_u32)) return 0;
	return buffer_peek(_buffer1, 8 + 4 * (_x + _y * _width), buffer_u32);
}

function buffer_getpixel(_buffer1, _x, _y) 
{
	/// buffer_getpixel(buffer:buffer, x:int, y:int)->int
	/// @param {buffer} buffer
	/// @param {int} x
	/// @param {int} y
	/// @returns {int}
	gml_pragma("forceinline");
	var _width;
	_x &= $7FFFFFFF;
	_y &= $7FFFFFFF;
	_width = buffer_peek(_buffer1, 0, buffer_u32);
	if (_x >= _width || _y >= buffer_peek(_buffer1, 4, buffer_u32)) return 0;
	return (buffer_peek(_buffer1, 8 + 4 * (_x + _y * _width), buffer_u32) & $FFFFFF);
}

function buffer_getpixel_r(_buffer1, _x, _y) 
{
	/// buffer_getpixel_r(buffer:buffer, x:int, y:int)->int
	/// @param {buffer} buffer
	/// @param {int} x
	/// @param {int} y
	/// @returns {int}
	gml_pragma("forceinline");
	var _width;
	_x &= $7FFFFFFF;
	_y &= $7FFFFFFF;
	_width = buffer_peek(_buffer1, 0, buffer_u32);
	if (_x >= _width || _y >= buffer_peek(_buffer1, 4, buffer_u32)) return 0;
	return buffer_peek(_buffer1, 8 + 4 * (_x + _y * _width), buffer_u8);
}

function buffer_getpixel_g(_buffer1, _x, _y) 
{
	/// buffer_getpixel_g(buffer:buffer, x:int, y:int)->int
	/// @param {buffer} buffer
	/// @param {int} x
	/// @param {int} y
	/// @returns {int}
	gml_pragma("forceinline");
	var _width;
	_x &= $7FFFFFFF;
	_y &= $7FFFFFFF;
	_width = buffer_peek(_buffer1, 0, buffer_u32);
	if (_x >= _width || _y >= buffer_peek(_buffer1, 4, buffer_u32)) return 0;
	return buffer_peek(_buffer1, 8 + 4 * (_x + _y * _width) + 1, buffer_u8);
}

function buffer_getpixel_b(_buffer1, _x, _y) 
{
	/// buffer_getpixel_b(buffer:buffer, x:int, y:int)->int
	/// @param {buffer} buffer
	/// @param {int} x
	/// @param {int} y
	/// @returns {int}
	gml_pragma("forceinline");
	var _width;
	_x &= $7FFFFFFF;
	_y &= $7FFFFFFF;
	_width = buffer_peek(_buffer1, 0, buffer_u32);
	if (_x >= _width || _y >= buffer_peek(_buffer1, 4, buffer_u32)) return 0;
	return buffer_peek(_buffer1, 8 + 4 * (_x + _y * _width) + 2, buffer_u8);
}

function buffer_getpixel_a(_buffer1, _x, _y) 
{
	/// buffer_getpixel_a(buffer:buffer, x:int, y:int)->int
	/// @param {buffer} buffer
	/// @param {int} x
	/// @param {int} y
	/// @returns {int}
	gml_pragma("forceinline");
	var _width;
	_x &= $7FFFFFFF;
	_y &= $7FFFFFFF;
	_width = buffer_peek(_buffer1, 0, buffer_u32);
	if (_x >= _width || _y >= buffer_peek(_buffer1, 4, buffer_u32)) return 0;
	return buffer_peek(_buffer1, 8 + 4 * (_x + _y * _width) + 3, buffer_u8);
}

#endregion
