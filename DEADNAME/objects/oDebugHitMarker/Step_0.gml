
//
for (var i = 0; i < array_length(trail_weights); i++)
{
	trail_weights[i] += trail_weights_spd[i] * trail_weight_spd * frame_delta;
}

trail_weight_spd *= power(trail_weight_mult, frame_delta);

trail_alpha -= trail_decay * frame_delta;
trail_alpha = trail_alpha < 0 ? 0 : trail_alpha;

//
hitmarker_destroy_timer -= frame_delta;

if (hitmarker_destroy_timer <= 0 and trail_alpha <= 0)
{
	instance_destroy();
}