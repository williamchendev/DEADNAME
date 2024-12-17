/// @description DO NOT MODIFY
//  SELF-CREATING GML+ MANAGER OBJECT

/*
FRAME TRACKING
*/

#region Update frametime properties
gmlp.frame.target	= (game_get_speed(gamespeed_microseconds)*0.000001);
gmlp.frame.time		= (delta_time*0.000001);
gmlp.frame.delta	= (gmlp.frame.time/gmlp.frame.target);
#endregion


/*
MOUSE TRACKING
*/

#region Update mouse movement properties
gmlp.mouse.hspeed		= (mouse_x - gmlp.mouse.xprevious);
gmlp.mouse.vspeed		= (mouse_y - gmlp.mouse.yprevious);
gmlp.mouse.speed		= point_distance(gmlp.mouse.xprevious, gmlp.mouse.yprevious, mouse_x, mouse_y);
gmlp.mouse.direction	= point_direction(gmlp.mouse.xprevious, gmlp.mouse.yprevious, mouse_x, mouse_y);
#endregion


/*
STEP TRACKING
*/

#region Update time properties to improve accuracy of `game_get_step()`
gmlp.time.step  = get_timer();
gmlp.time.loss += max(0, delta_time - game_get_speed(gamespeed_microseconds));
#endregion