/// @description Smoke Particle Combat Action Initialization
// Initializes the Smoke Particle Combat Action for Celestial Simulator Behaviour and Rendering

// Default Celestial Combat Action Initialization Behaviour
event_inherited();

// Celestial Battle Choreography Stack Type
choreography_stack_type = CelestialBattleChoreographyStackType.SmokeParticle;

// Smoke Particle's Depth Variables
smoke_particle_vertical_depth_y = 0;
smoke_particle_vertical_depth_offset = 0;

// Establish randomized spawn number of Smoke Particles
smoke_particle_count = irandom_range(smoke_particle_spawn_min, smoke_particle_spawn_max);

// Initialize Smoke Particle's Render Array
smoke_particle_render = array_create(smoke_particle_count, true);

// Initialize Smoke Particle's Rendering Variable Arrays
smoke_particle_image_index = array_create(smoke_particle_count);
smoke_particle_x = array_create(smoke_particle_count);
smoke_particle_y = array_create(smoke_particle_count);
smoke_particle_xscale = array_create(smoke_particle_count);
smoke_particle_yscale = array_create(smoke_particle_count);
smoke_particle_angle = array_create(smoke_particle_count);
smoke_particle_alpha = array_create(smoke_particle_count);
smoke_particle_color = array_create(smoke_particle_count);

// Initialize Smoke Particle's Physics Variable Arrays
smoke_particle_velocity_x = array_create(smoke_particle_count);
smoke_particle_velocity_y = array_create(smoke_particle_count);
smoke_particle_lifespan = array_create(smoke_particle_count);
smoke_particle_timer = array_create(smoke_particle_count);

// Establish Smoke Particle Combat Action Instance's Maximum Lifespan (Default -1, No Lifespan)
var temp_smoke_particle_lifespan_max = -1;

// Iterate through Smoke Particle Population Initialization Behaviour
var temp_smoke_particle_index = 0;

repeat (smoke_particle_count)
{
	// Establish Smoke Particle's Image Index
	smoke_particle_image_index[temp_smoke_particle_index] = irandom(sprite_get_number(sprite_index) - 1);
	
	// Establish Smoke Particle's Position (Offset from Combat Action Instance's Position)
	smoke_particle_x[temp_smoke_particle_index] = lerp(0, smoke_particle_horizontal_random_offset, power(random(1), 2)) * (random(1.0) > 0.5 ? 1 : -1) + smoke_particle_horizontal_offset;
	smoke_particle_y[temp_smoke_particle_index] = lerp(0, smoke_particle_vertical_random_offset, power(random(1), 2)) * (random(1.0) > 0.5 ? 1 : -1) + smoke_particle_vertical_offset;
	
	// Establish Smoke Particle's Randomized Size-Velocity Relationship Value (Bigger Smoke Particles are Slow, Smaller Smoke Particles are Fast)
	var temp_particle_size_and_velocity_value = random(1);
	
	// Establish Smoke Particle's Horizontal and Vertical Scale from Smoke Particle's Size
	var temp_smoke_particle_size = lerp(smoke_particle_size_max, smoke_particle_size_min, power(temp_particle_size_and_velocity_value, 2));
	smoke_particle_xscale[temp_smoke_particle_index] = temp_smoke_particle_size * (random(1.0) > 0.5 ? 1 : -1);
	smoke_particle_yscale[temp_smoke_particle_index] = temp_smoke_particle_size * (random(1.0) > 0.5 ? 1 : -1);
	
	// Establish Smoke Particle's Horizontal and Vertical Velocity from Smoke Particle's Random Direction and Velocity
	var temp_smoke_particle_direction = random_range(smoke_particle_direction_min, smoke_particle_direction_max);
	var temp_smoke_particle_velocity = lerp(smoke_particle_velocity_min, smoke_particle_velocity_max, power(temp_particle_size_and_velocity_value, 3));
	
	rot_prefetch(temp_smoke_particle_direction);
	
	smoke_particle_velocity_x[temp_smoke_particle_index] = temp_smoke_particle_velocity * rot_point_x(1, 0);
	smoke_particle_velocity_y[temp_smoke_particle_index] = temp_smoke_particle_velocity * rot_point_y(1, 0);
	
	// Establish Smoke Particle's Rotation
	smoke_particle_angle[temp_smoke_particle_index] = random(360);
	
	// Establish Smoke Particle's Color & Transparency
	smoke_particle_color[temp_smoke_particle_index] = c_white;
	smoke_particle_alpha[temp_smoke_particle_index] = 1;
	
	// Establish Smoke Particle's Lifespan & Timer
	smoke_particle_lifespan[temp_smoke_particle_index] = random_range(smoke_particle_lifespan_min, smoke_particle_lifespan_max);
	smoke_particle_timer[temp_smoke_particle_index] = 0;
	
	// Update Smoke Particle Combat Action Instance's Maximum Lifespan
	temp_smoke_particle_lifespan_max = max(smoke_particle_lifespan[temp_smoke_particle_index], temp_smoke_particle_lifespan_max);
	
	// Increment Smoke Particle Index
	temp_smoke_particle_index++;
}

// Update Smoke Particle Combat Action Instance's Action Duration & Timer
action_duration = temp_smoke_particle_lifespan_max;
action_timer = action_duration;

