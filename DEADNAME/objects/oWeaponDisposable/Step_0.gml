/// @description Disposable Update
// Performs the Weapon Disposable Object Behaviour

// Inherit the parent event
event_inherited();

// Bullet Case Timer
if (disposable_timer > 0) {
	disposable_timer -= disposable_timer_spd * global.deltatime;
}
else {
	image_alpha -= disposable_alpha_decay * global.deltatime;
	if (image_alpha <= 0) {
		instance_destroy();
	}
}
image_alpha = clamp(image_alpha, 0, 1);