/// @description Flame Movement
// Moves Point Light Source with Flame Dynamic Object


//
x = mouse_x + LightingEngine.render_x - 50;
y = mouse_y + LightingEngine.render_y - 50;

// Move Point Light with Dynamic Object
point_light_source.x = x;
point_light_source.y = y;
