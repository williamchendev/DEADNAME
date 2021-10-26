/// @description Insert description here
// You can write your code in this editor

if (blood_pool_value < 1) {
	blood_pool_value = lerp(blood_pool_value, 1, blood_pool_spd * global.deltatime);
	blood_pool_value = min(blood_pool_value, 1);
}