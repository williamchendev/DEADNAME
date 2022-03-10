/// @description Insert description here
// You can write your code in this editor

glow_value += glow_spd * global.deltatime;
glow_value = glow_value mod 1;

intensity = (cos(glow_value * 2 * pi) / 2) + 1;