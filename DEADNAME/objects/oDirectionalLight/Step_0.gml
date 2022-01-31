/// @description Insert description here
// You can write your code in this editor

time_value += time_speed * global.deltatime;
if (time_value >= 1) {
	time_value = time_value mod 1;	
}
if (time_value < 0) {
	time_value = (time_value + 1) mod 1;	
}

angle = 360 * time_value;