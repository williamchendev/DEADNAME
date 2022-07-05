/// @description Insert description here
// You can write your code in this editor

// Indian Pipe Movement
plant_angle = lerp(plant_angle, 0, lerp_spd * global.deltatime);
plant_yscale = lerp(plant_yscale, 1, lerp_spd * global.deltatime);

plant_angle = clamp(plant_angle, -45, 45);
image_angle = -plant_angle;
image_yscale = plant_yscale;

// Wind
wind_timer += wind_spd * global.deltatime;
if (wind_timer >= 1) {
	wind_timer--;
}
var temp_wind_hor_mult = cos(degtorad(wind_direction)) * ((cos(wind_timer * 2 * pi) / 2) + 1);
var temp_wind_vert_mult = sin(degtorad(wind_direction)) * ((sin(wind_timer * 2 * pi) / 2) + 1);
image_angle += temp_wind_hor_mult * wind_angle_intensity;
image_yscale += temp_wind_vert_mult * wind_yscale_intensity;