/// @description Insert description here
// You can write your code in this editor

// Life Decay
life -= frame_delta;

//
if (life <= 0)
{
	//
	instance_destroy();
}
