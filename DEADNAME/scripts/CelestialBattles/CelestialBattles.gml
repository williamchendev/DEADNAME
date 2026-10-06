// Global Celestial Battle Properties
#macro CelestialBattleCombatGridColumns 10
#macro CelestialBattleCombatGridRows 10

global.celestial_battle_combat_grid_column_type[0] = CelestialBattleColumnType.Frontline;
global.celestial_battle_combat_grid_column_type[1] = CelestialBattleColumnType.Frontline;
global.celestial_battle_combat_grid_column_type[2] = CelestialBattleColumnType.Frontline;
global.celestial_battle_combat_grid_column_type[3] = CelestialBattleColumnType.Frontline;
global.celestial_battle_combat_grid_column_type[4] = CelestialBattleColumnType.Frontline;
global.celestial_battle_combat_grid_column_type[5] = CelestialBattleColumnType.Midline;
global.celestial_battle_combat_grid_column_type[6] = CelestialBattleColumnType.Midline;
global.celestial_battle_combat_grid_column_type[7] = CelestialBattleColumnType.Midline;
global.celestial_battle_combat_grid_column_type[8] = CelestialBattleColumnType.Backline;
global.celestial_battle_combat_grid_column_type[9] = CelestialBattleColumnType.Backline;

global.celestial_battle_combat_grid_population_minimum = 5;

global.celestial_battle_unit_reinforcement_delay = 5;
global.celestial_battle_unit_retreat_angle_minimum = 60;

global.celestial_battle_exit_stage_animation_mult = 1.5;
global.celestial_battle_exit_stage_animation_spd = 0.02;
global.celestial_battle_exit_stage_animation_movement_distance = 32;

// Battle Enums
enum CelestialBattleColumnType
{
	Frontline,
	Midline,
	Backline
}

enum CelestialBattleCombatGridSide
{
	Left,
	None,
	Right
}

enum CelestialBattleChoreographyStackType
{
	Prop,
	CombatUnit,
	LinearProjectile,
	ArcProjectile,
	Hitmarker,
	SmokeParticle
}

#region Combat Action Functions
/// @function celestial_battle_calculate_combat_action_success(combat_action_instance);
/// @description Checks if a Combat Action was successful or not given the Combat Action's properties and the target of the Combat Action
/// @param {real:Id.Instance<oCelestialCombatAction>} combat_action_instance The Celestial Combat Action Instance to check the success of the action being performed
/// @returns {bool} Returns whether or not the Combat Action performed was successful
function celestial_battle_calculate_combat_action_success(combat_action_instance)
{
	// Establish Default Combat Action Success Value
	var temp_combat_action_success = false;
	
	// Check if Combat Action's Target still exists
	if (!instance_exists(combat_action_instance.target_combat_unit))
	{
		// Combat Action's Target Instance does not exist - Attempt to pull Target Combat Unit from Target Combat Grid Variables
		switch (combat_action_instance.target_combat_grid_side)
		{
			case CelestialBattleCombatGridSide.Left:
				// Combat Grid Left Side Target Instance Retrieval
				combat_action_instance.target_combat_unit = array_get(combat_action_instance.battle_instance.battle_combat_grid_a[combat_action_instance.target_combat_grid_column], combat_action_instance.target_combat_grid_row);
				break;
			case CelestialBattleCombatGridSide.Right:
				// Combat Grid Right Side Target Instance Retrieval
				combat_action_instance.target_combat_unit = array_get(combat_action_instance.battle_instance.battle_combat_grid_b[combat_action_instance.target_combat_grid_column], combat_action_instance.target_combat_grid_row);
				break;
			
		}
	}
	
	// Check if Combat Action has a Valid Target Combat Unit Instance
	if (instance_exists(combat_action_instance.target_combat_unit))
	{
		// Perform Combat Action Behaviour on Target Combat Unit Instance
		switch (combat_action_instance.action_type)
		{
			case CelestialCombatUnitActionType.Attack:
			case CelestialCombatUnitActionType.AttackLinearProjectile:
			case CelestialCombatUnitActionType.AttackArcProjectile:
				// Calculate Combat Action's Attack Success Chance
				var temp_combat_action_attack_accuracy = combat_action_instance.action_accuracy;
				var temp_combat_action_defend_evasion = combat_action_instance.target_combat_unit.combat_unit_evasion;
				var temp_combat_action_attack_success_chance = clamp(0.5 + (temp_combat_action_attack_accuracy - temp_combat_action_defend_evasion) * 0.05, 0, 1);
				
				// Calculate Combat Action's Attack Random Chance to hit the Target Combat Unit Instance
				var temp_combat_action_attack_random_chance = random(1.0);
				
				if (temp_combat_action_attack_random_chance <= temp_combat_action_attack_success_chance)
				{
					// Combat Action was Successful
					temp_combat_action_success = true;
				}
				break;
			case CelestialCombatUnitActionType.Support:
				// Combat Action was Successful
				temp_combat_action_success = true;
				break;
		}
	}
	
	// Return Combat Action's Success/Failure Value
	return temp_combat_action_success;
}

/// @function celestial_battle_perform_combat_action(combat_action_instance);
/// @description 
/// @param {real:Id.Instance<oCelestialCombatAction>} combat_action_instance The Celestial Combat Action Instance to perform the Action Behaviour of
function celestial_battle_perform_combat_action(combat_action_instance)
{
	
}

/// @function celestial_battle_arc_projectile_predict_angle(start_x, start_y, target_x, target_y, initial_velocity, projectile_gravity, air_resistance, high_angle = true);
/// @description Predicts the angle to fire a projectile given the properties of the arc as described by the start position, target position, projectile's initial velocity, gravity, and the projectile's air resistance
/// @param {real} start_x The x coordinate of the projectile's launch position
/// @param {real} start_y The y coordinate of the projectile's launch position
/// @param {real} target_x The x coordinate of the projectile's target destination
/// @param {real} target_y The y coordinate of the projectile's target destination
/// @param {real} initial_velocity The projectile's launch velocity
/// @param {real} projectile_gravity The projectile's gravity speed
/// @param {real} air_resistance The projectile's air resistance
/// @param {bool} high_angle (Optional) Determines whether to return the Quadratic "High" angle or "Low" angle, by default this function returns the "High" angle to create more dramatic projectile arcs
/// @returns {real} The predicted angle to launch the projectile as to hit the provided target position
function celestial_battle_arc_projectile_predict_angle(start_x, start_y, target_x, target_y, initial_velocity, projectile_gravity, air_resistance, high_angle = true)
{
	// Establish Projectile Position Displacement Variables
	var temp_delta_x = target_x - start_x;
	var temp_delta_y = -(target_y - start_y);
	
	// Establish Projectile Angle Prediction Math Variables
	var temp_inv_air_resist = 1 - air_resistance;
	var temp_initial_velocity_sqr = initial_velocity * initial_velocity;
	
	// Calculate Projectile Angle Prediction Equation Descriminator
	var temp_descriminator = temp_initial_velocity_sqr * temp_initial_velocity_sqr * temp_inv_air_resist * temp_inv_air_resist - projectile_gravity * ((projectile_gravity * temp_delta_x * temp_delta_x) + (2 * temp_delta_y * temp_initial_velocity_sqr * temp_inv_air_resist));
	
	// Check if Projectile Angle Prediction Equation Descriminator is Greater than Zero (if it is, the Target Position is within Reach of Projectile Trajectory's Path of Motion)
	if (temp_descriminator < 0)
	{
		// Target Position is NOT within Reach of Projectile Trajectory's Path of Motion - Return the Projectile Angle that matches the Trajectory of the Direction between the Projectile's Starting Position and the Projectile's Target Position
		var temp_direction = point_direction(start_x, start_y, target_x, target_y);
		return temp_direction + (angle_difference(90, temp_direction) * 0.4);
	}
	
	// Calculate Angle of Projectile Trajectory
	var temp_angle = radtodeg(arctan(((temp_initial_velocity_sqr * temp_inv_air_resist) + (sqrt(temp_descriminator) * (high_angle ? 1 : -1))) / (projectile_gravity * temp_delta_x)));
	
	// Return the Mirrored Angle
	return target_x < start_x ? (temp_angle + 180) mod 360 : temp_angle;
}
#endregion

#region Celestial Battle Functions
/// @function celestial_battle_create(celestial_object);
/// @description Creates and returns a Celestial Battle Instance within the Celestial Simulation with the given Celestial Object Instance and Hostile Celestial Factions, if the given Celestial Factions do not have a Hostile Relationship the Celestial Battle will not be created
/// @param {real:Id.Instance<oCelestialBody>} celestial_object The Celestial Object Instance the Celestial Battle will belong to
/// @param {real:Id.Instance<oCelestialFaction>} celestial_faction_a The first Celestial Faction Instance that is engaged in the Celestial Battle
/// @param {real:Id.Instance<oCelestialFaction>} celestial_faction_b The second Celestial Faction Instance that is engaged in the Celestial Battle
/// @returns {?real:Id.Instance<oCelestialBattle>} Returns a Celestial Battle Instance
function celestial_battle_create(celestial_object, celestial_faction_a, celestial_faction_b)
{
	// Check if the given Celestial Factions are hostile to eachother
	if (!celestial_faction_is_relationship_hostile(celestial_faction_a, celestial_faction_b))
	{
		// The Celestial Factions do not have a hostile relationship - Skip Battle Initialization and return null
		return noone;
	}
	
	// Create Celestial Battle Instance
	var temp_celestial_battle_instance = instance_create_depth(0, 0, 0, oCelestialBattle);
	
	// Update Celestial Battle's Celestial Body Instance
	temp_celestial_battle_instance.celestial_body_instance = celestial_object;
	
	// Update Celestial Battle's Faction Orientation (Player Faction must be placed on the Left-Hand Combat Grid)
	var temp_first_faction = celestial_faction_a;
	var temp_second_faction = celestial_faction_b;
	
	if (celestial_faction_b == CelestialSimulator.player_faction)
	{
		temp_first_faction = celestial_faction_b;
		temp_second_faction = celestial_faction_a;
	}
	else if (celestial_faction_a != CelestialSimulator.player_faction and random(1.0) > 0.5)
	{
		temp_first_faction = celestial_faction_b;
		temp_second_faction = celestial_faction_a;
	}
	
	temp_celestial_battle_instance.battle_faction_a = temp_first_faction;
	temp_celestial_battle_instance.battle_faction_b = temp_second_faction;
	
	// Calculate Combat Engagement Threshold
	temp_celestial_battle_instance.battle_near_collision_threshold = cos(temp_celestial_battle_instance.battle_near_collision_radius / celestial_object.radius);
	temp_celestial_battle_instance.battle_far_collision_threshold = cos(temp_celestial_battle_instance.battle_far_collision_radius / celestial_object.radius);
	
	// Index Celestial Battle Instance in Celestial Object Battle Array
	array_push(celestial_object.battles, temp_celestial_battle_instance);
	
	// Return Celestial Battle Instance
	return temp_celestial_battle_instance;
}

/// @function celestial_battle_check_for_duplicate(battle_instance);
/// @description Checks if there is a duplicate Celestial Battle Instance that shares the same Celestial Body Instance and list of Celestial Unit Instances engaged in combat as the Celestial Battle provided and returns its Instance
/// @param {real:Id.Instance<oCelestialBattle>} battle_instance The Celestial Battle to check for a duplicate instance of
/// @returns {real:Id.Instance<oCelestialBattle>} Returns a Celestial Battle Instance
function celestial_battle_check_for_duplicate(battle_instance)
{
	// Check if Celestial Body Instance exists
	if (instance_exists(battle_instance.celestial_body_instance))
	{
		// Find the Index of this Celestial Battle within the Celestial Body Instance's Battles Array
		var temp_battle_instance_celestial_body_battles_index = array_get_index(battle_instance.celestial_body_instance.battles, battle_instance);
		
		// Remove Celestial Battle Instance from Celestial Body's Battles Array
		var temp_celestial_body_battles_count = array_length(battle_instance.celestial_body_instance.battles);
		var temp_celestial_body_battles_index = temp_celestial_body_battles_count - 1;
		
		repeat (temp_celestial_body_battles_count)
		{
			// Check if Comparing the given Celestial Battle with itself
			if (temp_celestial_body_battles_index == temp_battle_instance_celestial_body_battles_index)
			{
				// Decrement Celestial Body Battles Index
				temp_celestial_body_battles_index--;
				
				// Skip Comparison
				continue;
			}
			
			// Find Celestial Body's Battle Instance
			var temp_celestial_body_battles_instance = battle_instance.celestial_body_instance.battles[temp_celestial_body_battles_index];
			
			// Check if the Celestial Body's Battle Instance has the same Celestial Units participating in Combat as the given Celestial Battle
			if (temp_celestial_body_battles_instance.battle_exists and array_equals(battle_instance.battle_units, temp_celestial_body_battles_instance.battle_units))
			{
				// Return Duplicate Battle Instance
				return temp_celestial_body_battles_instance;
			}
			
			// Decrement Celestial Body Battles Index
			temp_celestial_body_battles_index--;
		}
	}
	
	// Unable to find Duplicate Battle Instance - Return Null Instance
	return noone;
}
#endregion

#region Celestial Unit Functions
/// @function celestial_battle_add_unit(battle_instance, unit_instance);
/// @description Adds the given Celestial Unit Instance to the ongoing Battle with the provided Celestial Battle Instance (this function prevents Celestial Units from being redundantly "double added" to the Celestial Battle)
/// If the given Celestial Unit Instance is not allied with any of the factions and is not hostile to the opposing faction, they will add the Celestial Battle Instance as a Hazard to their Avoid Behaviour and move away from the vicinity of the Battle
/// @param {real:Id.Instance<oCelestialBattle>} battle_instance The Celestial Battle the given Celestial Unit Instance will be added to
/// @param {real:Id.Instance<oCelestialUnit>} unit_instance The Celestial Unit Instance that will be added to the given Celestial Battle Instance
function celestial_battle_add_unit(battle_instance, unit_instance)
{
	// Check if Battle Exists
	if (!battle_instance.battle_exists)
	{
		// Battle Instance does not exist - Early Exit
		return;
	}
	
	// Check if Battle and Unit Instances both share the same Celestial Body Instance
	if (battle_instance.celestial_body_instance != unit_instance.celestial_body_instance)
	{
		// Battle Instance and Unit Instance do not share the same Celestial Body Instance - Early Exit
		return;
	}
	
	// Establish Celestial Unit Instance's Battle Combat Grid Side
	var temp_battle_combat_grid_side = CelestialBattleCombatGridSide.None;
	
	// Determine the Combat Grid Side of the Celestial Unit Instance based on their Faction's Participation in the Battle
	if (celestial_faction_is_relationship_allied(unit_instance.unit_faction, battle_instance.battle_faction_a) and celestial_faction_is_relationship_hostile(unit_instance.unit_faction, battle_instance.battle_faction_b))
	{
		temp_battle_combat_grid_side = CelestialBattleCombatGridSide.Left;
	}
	else if (celestial_faction_is_relationship_allied(unit_instance.unit_faction, battle_instance.battle_faction_b) and celestial_faction_is_relationship_hostile(unit_instance.unit_faction, battle_instance.battle_faction_a))
	{
		temp_battle_combat_grid_side = CelestialBattleCombatGridSide.Right;
	}
	else
	{
		// Unit Instance is Factionally uninvolved with this conflict - Index Battle Instance as a Hazard to avoid for the Celestial Unit
		celestial_unit_add_avoid_instance(unit_instance, battle_instance, battle_instance.battle_far_collision_threshold);
		
		// Celestial Unit Instance is not involved in this conflict - Early Exit
		return;
	}
	
	// Check if Celestial Unit already is engaged with the Battle
	if (array_get_index(battle_instance.battle_units, unit_instance) != -1)
	{
		// Celestial Unit has already been added to this Battle - Early Exit
		return;
	}
	
	// Index Battle in Unit Instance's Engaged Celestial Battles Arrays
	array_push(unit_instance.engaged_battles, battle_instance);
	array_push(unit_instance.engaged_battles_combat_units, array_create(0));
	array_push(unit_instance.engaged_battles_combat_units_contribution, 0);
	
	// Index and Sort the given Celestial Unit in Battle's Celestial Units Array
	array_push(battle_instance.battle_units, unit_instance);
	array_sort(battle_instance.battle_units, true);
	
	// Index Celestial Unit in Battle's Factional Celestial Units Arrays
	switch (temp_battle_combat_grid_side)
	{
		case CelestialBattleCombatGridSide.Left:
			array_push(battle_instance.battle_units_a, unit_instance);
			break;
		case CelestialBattleCombatGridSide.Right:
			array_push(battle_instance.battle_units_b, unit_instance);
			break;
	}
	
	// Update Unit Instance's Randomized Battle Reinforcement Timer
	if (!unit_instance.engaged_in_battle)
	{
		unit_instance.battle_reinforcement_timer = random(global.celestial_battle_unit_reinforcement_delay);
	}
	
	// Update Unit Instance's Facing Direction towards the Battle
	if (instance_exists(battle_instance.celestial_body_instance))
	{
		// Update Unit's Sprite Facing Direction
		var temp_unit_facing_direction = celestial_unit_calculate_spherical_facing_direction(unit_instance.sphere_vector_x, unit_instance.sphere_vector_z, battle_instance.sphere_vector_x, battle_instance.sphere_vector_z);
		unit_instance.image_xscale = temp_unit_facing_direction != 0 ? temp_unit_facing_direction : unit_instance.image_xscale;
	}
	
	// Update that Unit Instance has entered Combat
	unit_instance.engaged_in_battle = true;
	
	// Update Unit Instance's Battle Popup
	unit_instance.emotion_battle_popup_timer = unit_instance.emotion_battle_popup_duration;
	
	// Randomize Unit Instance's Collision Check Timer
	unit_instance.collision_check_timer = random(CelestialSimulator.global_collision_check_interval);
	
	// Load Celestial Unit's Combat Units into this Battle
	celestial_battle_load_combat_units(battle_instance, unit_instance);
}

/// @function celestial_battle_remove_unit(battle_instance, unit_instance);
/// @description Removes the given Celestial Unit Instance from the provided Celestial Battle Instance (this function can end a Celestial Battle if the Celestial Unit being removed is the last participating Unit within one of the Battle's Factions)
/// @param {real:Id.Instance<oCelestialBattle>} battle_instance The Celestial Battle the given Celestial Unit Instance will be removed from
/// @param {real:Id.Instance<oCelestialUnit>} unit_instance The Celestial Unit Instance that will be removed from the given Celestial Battle Instance
/// @param {bool} leave_animation Toggles whether or not to instantiate the Leave Battle Combat Unit animation when removing the Celestial Unit's Combat Units from the Celestial Battle (off by default)
function celestial_battle_remove_unit(battle_instance, unit_instance, leave_animation = false)
{
	// Find the index of the given Celestial Unit Instance within the Celestial Battle's Celestial Units Array
	var temp_battle_units_index = array_get_index(battle_instance.battle_units, unit_instance);
	
	// Check if given Celestial Unit Instance is engaged in the Celestial Battle
	if (temp_battle_units_index == -1)
	{
		// Celestial Unit Instance is not indexed within the Celestial Battle - Early Return
		return;
	}
	
	// Delete Celestial Unit Instance's Entry within the Celestial Battle's Celestial Units Array
	array_delete(battle_instance.battle_units, temp_battle_units_index, 1);
	
	// Check if Celestial Unit Instance was indexed on the Left or Right Factional Celestial Units Array
	var temp_battle_units_left_index = array_get_index(battle_instance.battle_units_a, unit_instance);
	
	if (temp_battle_units_left_index == -1)
	{
		// Find the index of the given Celestial Unit Instance within the Celestial Battle's Right-Side Celestial Units Array
		var temp_battle_units_right_index = array_get_index(battle_instance.battle_units_b, unit_instance);
		
		// Remove the Celestial Unit Instance from the Celestial Battle's Right-Side Celestial Units Array
		array_delete(battle_instance.battle_units_b, temp_battle_units_right_index, 1);
		
		// Check if there are any more Celestial Unit Instances fighting on the Right-Side of the Celestial Battle
		if (array_length(battle_instance.battle_units_b) < 1)
		{
			// Toggle the Celestial Battle has ended
			battle_instance.battle_exists = false;
		}
	}
	else
	{
		// Remove the Celestial Unit Instance from the Celestial Battle's Left-Side Celestial Units Array
		array_delete(battle_instance.battle_units_a, temp_battle_units_left_index, 1);
		
		// Check if there are any more Celestial Unit Instances fighting on the Left-Side of the Celestial Battle
		if (array_length(battle_instance.battle_units_a) < 1)
		{
			// Toggle the Celestial Battle has ended
			battle_instance.battle_exists = false;
		}
	}
	
	// Iterate through Celestial Unit's Engaged Frontline Combat Units Array to remove them from the current Battle
	var temp_frontline_engaged_combat_unit_count = array_length(unit_instance.frontline_combat_unit_engaged);
	var temp_frontline_engaged_combat_unit_index = temp_frontline_engaged_combat_unit_count - 1;
	
	repeat (temp_frontline_engaged_combat_unit_count)
	{
		// Find the Engaged Combat Unit Instance
		var temp_frontline_engaged_combat_unit_instance = unit_instance.frontline_combat_unit_engaged[temp_frontline_engaged_combat_unit_index];
		
		// Check if Engaged Combat Unit Instance is participating in the given Celestial Battle
		if (temp_frontline_engaged_combat_unit_instance.battle_instance == battle_instance)
		{
			// Remove the Engaged Combat Unit Instance from the Celestial Battle
			celestial_battle_remove_combat_unit(battle_instance, temp_frontline_engaged_combat_unit_instance, leave_animation);
		}
		
		// Decrement the Engaged Combat Unit Index
		temp_frontline_engaged_combat_unit_index--;
	}
	
	// Iterate through Celestial Unit's Engaged Midline Combat Units Array to remove them from the current Battle
	var temp_midline_engaged_combat_unit_count = array_length(unit_instance.midline_combat_unit_engaged);
	var temp_midline_engaged_combat_unit_index = temp_midline_engaged_combat_unit_count - 1;
	
	repeat (temp_midline_engaged_combat_unit_count)
	{
		// Find the Engaged Combat Unit Instance
		var temp_midline_engaged_combat_unit_instance = unit_instance.midline_combat_unit_engaged[temp_midline_engaged_combat_unit_index];
		
		// Check if Engaged Combat Unit Instance is participating in the given Celestial Battle
		if (temp_midline_engaged_combat_unit_instance.battle_instance == battle_instance)
		{
			// Remove the Engaged Combat Unit Instance from the Celestial Battle
			celestial_battle_remove_combat_unit(battle_instance, temp_midline_engaged_combat_unit_instance, leave_animation);
		}
		
		// Decrement the Engaged Combat Unit Index
		temp_midline_engaged_combat_unit_index--;
	}
	
	// Iterate through Celestial Unit's Engaged Backline Combat Units Array to remove them from the current Battle
	var temp_backline_engaged_combat_unit_count = array_length(unit_instance.backline_combat_unit_engaged);
	var temp_backline_engaged_combat_unit_index = temp_backline_engaged_combat_unit_count - 1;
	
	repeat (temp_backline_engaged_combat_unit_count)
	{
		// Find the Engaged Combat Unit Instance
		var temp_backline_engaged_combat_unit_instance = unit_instance.backline_combat_unit_engaged[temp_backline_engaged_combat_unit_index];
		
		// Check if Engaged Combat Unit Instance is participating in the given Celestial Battle
		if (temp_backline_engaged_combat_unit_instance.battle_instance == battle_instance)
		{
			// Remove the Engaged Combat Unit Instance from the Celestial Battle
			celestial_battle_remove_combat_unit(battle_instance, temp_backline_engaged_combat_unit_instance, leave_animation);
		}
		
		// Decrement the Engaged Combat Unit Index
		temp_backline_engaged_combat_unit_index--;
	}
	
	// Remove Battle from Celestial Unit's Engaged Celestial Battles Arrays
	var temp_engaged_battles_index = array_get_index(unit_instance.engaged_battles, battle_instance);
	array_delete(unit_instance.engaged_battles, temp_engaged_battles_index, 1);
	array_delete(unit_instance.engaged_battles_combat_units, temp_engaged_battles_index, 1);
	array_delete(unit_instance.engaged_battles_combat_units_contribution, temp_engaged_battles_index, 1);
	
	// Check if Celestial Unit is still engaged in Battle
	if (array_length(unit_instance.engaged_battles) < 1)
	{
		// Toggle Celestial Unit is no longer participating in Combat
		unit_instance.engaged_in_battle = false;
	}
	else
	{
		// Load Combat Units into Celestial Unit's next available Engaged Battle
		celestial_battle_load_combat_units(unit_instance.engaged_battles[0], unit_instance);
	}
	
	// Duplicate Battle Prevention Behaviour
	if (battle_instance.battle_exists)
	{
		// Search for Battle's Duplicate Instance
		var temp_battle_duplicate_instance = celestial_battle_check_for_duplicate(battle_instance);
		
		// Check if Duplicate Battle Exists
		if (instance_exists(temp_battle_duplicate_instance))
		{
			// Duplicate Battle Exists - Toggle that the given Celestial Battle has ended
			battle_instance.battle_exists = false;
		}
	}
}

/// @function celestial_battle_load_combat_units(battle_instance, unit_instance, combat_units_count);
/// @description Loads Combat Units indexed within the given Celestial Unit Instance to be loaded into the provided Celestial Battle Instance
/// @param {real:Id.Instance<oCelestialBattle>} battle_instance The Celestial Battle Instance the given Celestial Unit Instance will be loading Combat Units into
/// @param {real:Id.Instance<oCelestialUnit>} unit_instance The Celestial Unit Instance that will be loading Combat Units into the given Celestial Battle Instance
/// @param {int} combat_units_count The maximum limit of Combat Units to add into the Celestial Battle, by default this number is set to "-1" which causes the maximum limit to be disabled/unenforced
function celestial_battle_load_combat_units(battle_instance, unit_instance, combat_units_count = -1)
{
	// Check if Battle Exists
	if (!battle_instance.battle_exists)
	{
		// Battle Instance does not exist - Early Exit
		return;
	}
	
	// Establish Celestial Unit Instance's Battle Combat Grid Side
	var temp_battle_combat_grid_side = CelestialBattleCombatGridSide.None;
	
	// Determine the Combat Grid Side of the Celestial Unit Instance based on their Faction's Participation in the Battle
	if (celestial_faction_is_relationship_allied(unit_instance.unit_faction, battle_instance.battle_faction_a) and celestial_faction_is_relationship_hostile(unit_instance.unit_faction, battle_instance.battle_faction_b))
	{
		temp_battle_combat_grid_side = CelestialBattleCombatGridSide.Left;
	}
	else if (celestial_faction_is_relationship_allied(unit_instance.unit_faction, battle_instance.battle_faction_b) and celestial_faction_is_relationship_hostile(unit_instance.unit_faction, battle_instance.battle_faction_a))
	{
		temp_battle_combat_grid_side = CelestialBattleCombatGridSide.Right;
	}
	else
	{
		// Celestial Unit Instance is not involved in this conflict - Early Exit
		return;
	}
	
	// Establish Add Combat Unit Toggle & Combat Unit Added Count
	var temp_can_add_units = true;
	var temp_combat_units_added = 0;
	
	// Establish Combat Grid Column Type Unengaged Combat Unit Counts
	var temp_frontline_combat_unit_count = array_length(unit_instance.frontline_combat_unit_unengaged);
	var temp_midline_combat_unit_count = array_length(unit_instance.midline_combat_unit_unengaged);
	var temp_backline_combat_unit_count = array_length(unit_instance.backline_combat_unit_unengaged);
	
	// Establish Combat Grid Column Type Add Combat Unit Toggles
	var temp_can_add_frontline_units = temp_battle_combat_grid_side == CelestialBattleCombatGridSide.Left ? (battle_instance.battle_frontline_available_slots_count_a > 0) : (battle_instance.battle_frontline_available_slots_count_b > 0);
	var temp_can_add_midline_units = temp_battle_combat_grid_side == CelestialBattleCombatGridSide.Left ? (battle_instance.battle_midline_available_slots_count_a > 0) : (battle_instance.battle_midline_available_slots_count_b > 0);
	var temp_can_add_backline_units = temp_battle_combat_grid_side == CelestialBattleCombatGridSide.Left ? (battle_instance.battle_backline_available_slots_count_a > 0) : (battle_instance.battle_backline_available_slots_count_b > 0);
	
	// Check if Unit can still add more Combat Units to Battle
	while (temp_can_add_units)
	{
		// Check Combat Grid Column Types for available slots for the First Unit's Combat Units
		if (temp_can_add_frontline_units and temp_frontline_combat_unit_count > 0)
		{
			// Find random Unengaged Frontline Combat Unit from the First Unit
			var temp_random_frontline_combat_unit_index = irandom(temp_frontline_combat_unit_count - 1);
			var temp_random_frontline_combat_unit_instance = array_get(unit_instance.frontline_combat_unit_unengaged, temp_random_frontline_combat_unit_index);
			
			// Add random Unengaged Frontline Combat Unit to the Celestial Battle
			celestial_battle_add_combat_unit(battle_instance, temp_random_frontline_combat_unit_instance, temp_battle_combat_grid_side);
			
			// Increment Combat Units Added
			temp_combat_units_added++;
			
			// Decrement Frontline Combat Unit Count
			temp_frontline_combat_unit_count--;
			
			// Check if more Combat Units can be added to the Combat Grid's Frontline
			temp_can_add_frontline_units = temp_battle_combat_grid_side == CelestialBattleCombatGridSide.Left ? (battle_instance.battle_frontline_available_slots_count_a > 0) : (battle_instance.battle_frontline_available_slots_count_b > 0);
		}
		else if (temp_can_add_midline_units and temp_midline_combat_unit_count > 0)
		{
			// Find random Unengaged Midline Combat Unit from the First Unit
			var temp_random_midline_combat_unit_index = irandom(temp_midline_combat_unit_count - 1);
			var temp_random_midline_combat_unit_instance = array_get(unit_instance.midline_combat_unit_unengaged, temp_random_midline_combat_unit_index);
			
			// Add random Unengaged Midline Combat Unit to the Celestial Battle
			celestial_battle_add_combat_unit(battle_instance, temp_random_midline_combat_unit_instance, temp_battle_combat_grid_side);
			
			// Increment Combat Units Added
			temp_combat_units_added++;
			
			// Decrement Midline Combat Unit Count
			temp_midline_combat_unit_count--;
			
			// Check if more Combat Units can be added to the Combat Grid's Midline
			temp_can_add_midline_units = temp_battle_combat_grid_side == CelestialBattleCombatGridSide.Left ? (battle_instance.battle_midline_available_slots_count_a > 0) : (battle_instance.battle_midline_available_slots_count_b > 0);
		}
		else if (temp_can_add_backline_units and temp_backline_combat_unit_count > 0)
		{
			// Find random Unengaged Backline Combat Unit from the First Unit
			var temp_random_backline_combat_unit_index = irandom(temp_backline_combat_unit_count - 1);
			var temp_random_backline_combat_unit_instance = array_get(unit_instance.backline_combat_unit_unengaged, temp_random_backline_combat_unit_index);
			
			// Add random Unengaged Backline Combat Unit to the Celestial Battle
			celestial_battle_add_combat_unit(battle_instance, temp_random_backline_combat_unit_instance, temp_battle_combat_grid_side);
			
			// Increment Combat Units Added
			temp_combat_units_added++;
			
			// Decrement Backline Combat Unit Count
			temp_backline_combat_unit_count--;
			
			// Check if more Combat Units can be added to the Combat Grid's Backline
			temp_can_add_backline_units = temp_battle_combat_grid_side == CelestialBattleCombatGridSide.Left ? (battle_instance.battle_backline_available_slots_count_a > 0) : (battle_instance.battle_backline_available_slots_count_b > 0);
		}
		else
		{
			// There are no more Available Slots on the Combat Grid for the First Unit's Combat Units to occupy or the First Unit has no more available Combat Units to add to the Combat Grid
			temp_can_add_units = false;
		}
		
		// Check if Combat Units Added count exceeds the limit of Combat Units to add to the Battle
		if (combat_units_count != -1 and temp_can_add_units >= combat_units_count)
		{
			// Toggle Combat Units Added count has met or exceeds the limit of Combat Units to add to the Battle - End adding Combat Units to Battle Behaviour
			temp_can_add_units = false;
		}
	}
}
#endregion

#region Combat Unit Functions
/// @function celestial_battle_add_combat_unit(battle_instance, combat_unit_instance, combat_grid_side);
/// @description Adds a Combat Unit Instance to the given Celestial Battle Instance
/// @param {real:Id.Instance<oCelestialBattle>} battle_instance The Celestial Battle Instance the given Combat Unit Instance will be added to
/// @param {real:Id.Instance<oCelestialUnit>} combat_unit_instance The Combat Unit Instance that will be added to the given Celestial Battle Instance
/// @param {int<CelestialBattleCombatGridSide>} combat_grid_side The Combat Grid side of the Celestial Battle to add the given Combat Unit Instance to, if set to "None" this function will check the Faction of the Combat Unit Instance and add the unit to the appropriate side
function celestial_battle_add_combat_unit(battle_instance, combat_unit_instance, combat_grid_side = CelestialBattleCombatGridSide.None)
{
	// Check if Battle Exists
	if (!battle_instance.battle_exists)
	{
		// Battle Instance does not exist - Early Exit
		return;
	}
	
	// Establish Celestial Unit Instance's Battle Combat Grid Side
	var temp_battle_combat_grid_side = combat_grid_side;
	
	// Check if Combat Grid Side was already Determined
	if (temp_battle_combat_grid_side == CelestialBattleCombatGridSide.None)
	{
		// Determine the Combat Grid Side of the Combat Unit Instance based on their Faction's Participation in the Battle
		if (celestial_faction_is_relationship_allied(combat_unit_instance.unit_instance.unit_faction, battle_instance.battle_faction_a) and celestial_faction_is_relationship_hostile(combat_unit_instance.unit_instance.unit_faction, battle_instance.battle_faction_b))
		{
			temp_battle_combat_grid_side = CelestialBattleCombatGridSide.Left;
		}
		else if (celestial_faction_is_relationship_allied(combat_unit_instance.unit_instance.unit_faction, battle_instance.battle_faction_b) and celestial_faction_is_relationship_hostile(combat_unit_instance.unit_instance.unit_faction, battle_instance.battle_faction_a))
		{
			temp_battle_combat_grid_side = CelestialBattleCombatGridSide.Right;
		}
		else
		{
			// Combat Unit Instance is not involved in this conflict - Early Exit
			return;
		}
	}
	
	// Establish Combat Unit's Type & Combat Grid Available Slot
	var temp_combat_unit_type = combat_unit_instance.combat_unit_type;
	var temp_combat_grid_available_slot = -1;
	
	// Search for an Available Slot within the Battle's Combat Grid for the given Combat Unit
	switch (global.celestial_combat_units[temp_combat_unit_type].unit_combat_column_type)
	{
		case CelestialBattleColumnType.Frontline:
			// Find Combat Unit's Unengaged Index
			var temp_frontline_combat_unit_unengaged_index = array_get_index(combat_unit_instance.unit_instance.frontline_combat_unit_unengaged, combat_unit_instance);
			
			// Check if Combat Unit is currently Engaged in Combat
			if (temp_frontline_combat_unit_unengaged_index == -1)
			{
				// Combat Unit is currently Engaged in Combat - Early Return
				return;
			}
			
			// Find the index of the Combat Unit's Type within their Unit Instance's Combat Unit Types Array
			var temp_frontline_combat_unit_type_index = array_get_index(combat_unit_instance.unit_instance.frontline_combat_unit_type, temp_combat_unit_type);
			
			// Move Selected Combat Unit from Unengaged Array to Engaged Array
			combat_unit_instance.unit_instance.frontline_combat_unit_unengaged_count[temp_frontline_combat_unit_type_index] -= 1;
			array_delete(combat_unit_instance.unit_instance.frontline_combat_unit_unengaged, temp_frontline_combat_unit_unengaged_index, 1);
			array_push(combat_unit_instance.unit_instance.frontline_combat_unit_engaged, combat_unit_instance);
			
			// Add Selected Combat Unit to Battle's Faction Combat Unit Pools
			switch (temp_battle_combat_grid_side)
			{
				case CelestialBattleCombatGridSide.Left:
					// Find random Available Slot in the Combat Grid's Frontline
					var temp_random_frontline_combat_grid_available_slot_index_a = irandom(battle_instance.battle_frontline_available_slots_count_a - 1);
					temp_combat_grid_available_slot = array_get(battle_instance.battle_frontline_available_slots_a, temp_random_frontline_combat_grid_available_slot_index_a);
					
					// Remove Available Slot from Available Slot Array
					array_delete(battle_instance.battle_frontline_available_slots_a, temp_random_frontline_combat_grid_available_slot_index_a, 1);
					
					// Decrement Combat Grid Available Slots Count
					battle_instance.battle_frontline_available_slots_count_a--;
					break;
				case CelestialBattleCombatGridSide.Right:
					// Find random Available Slot in the Combat Grid's Frontline
					var temp_random_frontline_combat_grid_available_slot_index_b = irandom(battle_instance.battle_frontline_available_slots_count_b - 1);
					temp_combat_grid_available_slot = array_get(battle_instance.battle_frontline_available_slots_b, temp_random_frontline_combat_grid_available_slot_index_b);
					
					// Remove Available Slot from Available Slot Array
					array_delete(battle_instance.battle_frontline_available_slots_b, temp_random_frontline_combat_grid_available_slot_index_b, 1);
					
					// Decrement Combat Grid Available Slots Count
					battle_instance.battle_frontline_available_slots_count_b--;
					break;
			}
			break;
		case CelestialBattleColumnType.Midline:
			// Find Combat Unit's Unengaged Index
			var temp_midline_combat_unit_unengaged_index = array_get_index(combat_unit_instance.unit_instance.midline_combat_unit_unengaged, combat_unit_instance);
			
			// Check if Combat Unit is currently Engaged in Combat
			if (temp_midline_combat_unit_unengaged_index == -1)
			{
				// Combat Unit is currently Engaged in Combat - Early Return
				return;
			}
			
			// Find the index of the Combat Unit's Type within their Unit Instance's Combat Unit Types Array
			var temp_midline_combat_unit_type_index = array_get_index(combat_unit_instance.unit_instance.midline_combat_unit_type, temp_combat_unit_type);
			
			// Move Selected Combat Unit from Unengaged Array to Engaged Array
			combat_unit_instance.unit_instance.midline_combat_unit_unengaged_count[temp_midline_combat_unit_type_index] -= 1;
			array_delete(combat_unit_instance.unit_instance.midline_combat_unit_unengaged, temp_midline_combat_unit_unengaged_index, 1);
			array_push(combat_unit_instance.unit_instance.midline_combat_unit_engaged, combat_unit_instance);
			
			// Add Selected Combat Unit to Battle's Faction Combat Unit Pools
			switch (temp_battle_combat_grid_side)
			{
				case CelestialBattleCombatGridSide.Left:
					// Find random Available Slot in the Combat Grid's Midline
					var temp_random_midline_combat_grid_available_slot_index_a = irandom(battle_instance.battle_midline_available_slots_count_a - 1);
					temp_combat_grid_available_slot = array_get(battle_instance.battle_midline_available_slots_a, temp_random_midline_combat_grid_available_slot_index_a);
					
					// Remove Available Slot from Available Slot Array
					array_delete(battle_instance.battle_midline_available_slots_a, temp_random_midline_combat_grid_available_slot_index_a, 1);
					
					// Decrement Combat Grid Available Slots Count
					battle_instance.battle_midline_available_slots_count_a--;
					break;
				case CelestialBattleCombatGridSide.Right:
					// Find random Available Slot in the Combat Grid's Midline
					var temp_random_midline_combat_grid_available_slot_index_b = irandom(battle_instance.battle_midline_available_slots_count_b - 1);
					temp_combat_grid_available_slot = array_get(battle_instance.battle_midline_available_slots_b, temp_random_midline_combat_grid_available_slot_index_b);
					
					// Remove Available Slot from Available Slot Array
					array_delete(battle_instance.battle_midline_available_slots_b, temp_random_midline_combat_grid_available_slot_index_b, 1);
					
					// Decrement Combat Grid Available Slots Count
					battle_instance.battle_midline_available_slots_count_b--;
					break;
			}
			break;
		case CelestialBattleColumnType.Backline:
			// Find Combat Unit's Unengaged Index
			var temp_backline_combat_unit_unengaged_index = array_get_index(combat_unit_instance.unit_instance.backline_combat_unit_unengaged, combat_unit_instance);
			
			// Check if Combat Unit is currently Engaged in Combat
			if (temp_backline_combat_unit_unengaged_index == -1)
			{
				// Combat Unit is currently Engaged in Combat - Early Return
				return;
			}
			
			// Find the index of the Combat Unit's Type within their Unit Instance's Combat Unit Types Array
			var temp_backline_combat_unit_type_index = array_get_index(combat_unit_instance.unit_instance.backline_combat_unit_type, temp_combat_unit_type);
			
			// Move Selected Combat Unit from Unengaged Array to Engaged Array
			combat_unit_instance.unit_instance.backline_combat_unit_unengaged_count[temp_backline_combat_unit_type_index] -= 1;
			array_delete(combat_unit_instance.unit_instance.backline_combat_unit_unengaged, temp_backline_combat_unit_unengaged_index, 1);
			array_push(combat_unit_instance.unit_instance.backline_combat_unit_engaged, combat_unit_instance);
			
			// Add Selected Combat Unit to Battle's Faction Combat Unit Pools
			switch (temp_battle_combat_grid_side)
			{
				case CelestialBattleCombatGridSide.Left:
					// Find random Available Slot in the Combat Grid's Backline
					var temp_random_backline_combat_grid_available_slot_index_a = irandom(battle_instance.battle_backline_available_slots_count_a - 1);
					temp_combat_grid_available_slot = array_get(battle_instance.battle_backline_available_slots_a, temp_random_backline_combat_grid_available_slot_index_a);
					
					// Remove Available Slot from Available Slot Array
					array_delete(battle_instance.battle_backline_available_slots_a, temp_random_backline_combat_grid_available_slot_index_a, 1);
					
					// Decrement Combat Grid Available Slots Count
					battle_instance.battle_backline_available_slots_count_a--;
					break;
				case CelestialBattleCombatGridSide.Right:
					// Find random Available Slot in the Combat Grid's Backline
					var temp_random_backline_combat_grid_available_slot_index_b = irandom(battle_instance.battle_backline_available_slots_count_b - 1);
					temp_combat_grid_available_slot = array_get(battle_instance.battle_backline_available_slots_b, temp_random_backline_combat_grid_available_slot_index_b);
					
					// Remove Available Slot from Available Slot Array
					array_delete(battle_instance.battle_backline_available_slots_b, temp_random_backline_combat_grid_available_slot_index_b, 1);
					
					// Decrement Combat Grid Available Slots Count
					battle_instance.battle_backline_available_slots_count_b--;
					break;
			}
			break;
		default:
			break;
	}
	
	// Set Selected Combat Unit's Column and Row from Available Slot Index
	combat_unit_instance.combat_grid_column = temp_combat_grid_available_slot div CelestialBattleCombatGridRows;
	combat_unit_instance.combat_grid_row = temp_combat_grid_available_slot mod CelestialBattleCombatGridRows;
	
	// Set Selected Combat Unit's Facing Direction
	combat_unit_instance.combat_grid_side = temp_battle_combat_grid_side;
	combat_unit_instance.draw_xscale = temp_battle_combat_grid_side == CelestialBattleCombatGridSide.Left ? 1 : -1;
	
	// Set Combat Unit's Battle Instance
	combat_unit_instance.battle_instance = battle_instance;
	
	// Find the index of this Battle Instance within the Combat Unit's Celestial Unit's Engaged Battles Array, Increment their Battle Combat Unit Contribution, and add the Combat Unit to the Engaged Battle Combat Unit Array
	var temp_engaged_battles_index = array_get_index(combat_unit_instance.unit_instance.engaged_battles, battle_instance);
	combat_unit_instance.unit_instance.engaged_battles_combat_units_contribution[temp_engaged_battles_index] += 1;
	array_push(combat_unit_instance.unit_instance.engaged_battles_combat_units[temp_engaged_battles_index], combat_unit_instance);
	
	// Add Selected Combat Unit to Battle's Combat Units Pool
	array_insert(battle_instance.battle_combat_units, 0, combat_unit_instance);
	
	// Add Selected Combat Unit to Battle's Faction Combat Unit Pools
	switch (temp_battle_combat_grid_side)
	{
		case CelestialBattleCombatGridSide.Left:
			array_push(battle_instance.battle_combat_units_a, combat_unit_instance);
			combat_unit_instance.combat_grid_tile = array_get(battle_instance.battle_combat_grid_a_structs[combat_unit_instance.combat_grid_column], combat_unit_instance.combat_grid_row);
			break;
		case CelestialBattleCombatGridSide.Right:
			array_push(battle_instance.battle_combat_units_b, combat_unit_instance);
			combat_unit_instance.combat_grid_tile = array_get(battle_instance.battle_combat_grid_b_structs[combat_unit_instance.combat_grid_column], combat_unit_instance.combat_grid_row);
			break;
	}
	
	// Decrement the Combat Unit's Celestial Unit Unengaged Combat Units Count
	combat_unit_instance.unit_instance.combat_unit_unengaged_count--;
	
	// Reset Combat Unit Instance's Celestial Battle Behaviour
	celestial_battle_reset_combat_unit(combat_unit_instance);
}

/// @function celestial_battle_remove_combat_unit(battle_instance, combat_unit_instance);
/// @description Removes a Combat Unit Instance from the given Celestial Battle Instance
/// @param {real:Id.Instance<oCelestialBattle>} battle_instance The Celestial Battle Instance the given Combat Unit Instance will be removed from
/// @param {real:Id.Instance<oCelestialCombatUnit>} combat_unit_instance The Combat Unit Instance to be removed from the given Celestial Battle Instance
/// @param {bool} leave_animation Toggles whether or not to instantiate the Leave Battle Combat Unit animation when removing the Combat Unit from the Celestial Battle (off by default)
function celestial_battle_remove_combat_unit(battle_instance, combat_unit_instance, leave_animation = false)
{
	// Find Combat Unit's Index within the Celestial Battle's Combat Units Array
	var temp_battle_combat_unit_index = array_get_index(battle_instance.battle_combat_units, combat_unit_instance);
	
	// Check if Combat Unit exists within the Celestial Battle
	if (temp_battle_combat_unit_index == -1)
	{
		// Combat Unit doesn't exist in the Celestial Battle - Early Return
		return;
	}
	
	// Delete the Combat Unit Instance from the Celestial Battle's Combat Units Array
	array_delete(battle_instance.battle_combat_units, temp_battle_combat_unit_index, 1);
	
	// Perform Combat Unit's Leave Battle Behaviour
	if (leave_animation)
	{
		celestial_battle_combat_unit_leave(battle_instance, combat_unit_instance);
	}
	
	// Find the index of this Battle Instance within the Combat Unit's Celestial Unit's Engaged Battles Array and Decrement their Battle Combat Unit Contribution
	var temp_engaged_battles_index = array_get_index(combat_unit_instance.unit_instance.engaged_battles, battle_instance);
	combat_unit_instance.unit_instance.engaged_battles_combat_units_contribution[temp_engaged_battles_index] -= 1;
	
	// Remove the Combat Unit from their Celestial Unit's Engaged Battles Combat Units Array
	var temp_engaged_battles_combat_unit_index = array_get_index(combat_unit_instance.unit_instance.engaged_battles_combat_units[temp_engaged_battles_index], combat_unit_instance);
	array_delete(combat_unit_instance.unit_instance.engaged_battles_combat_units[temp_engaged_battles_index], temp_engaged_battles_combat_unit_index, 1);
	
	// Check Combat Unit's Grid Direction
	switch (combat_unit_instance.combat_grid_side)
	{
		case CelestialBattleCombatGridSide.Left:
			// Remove Combat Unit Instance from Celestial Battle's Combat Column Type Arrays
			switch (global.celestial_combat_units[combat_unit_instance.combat_unit_type].unit_combat_column_type)
			{
				case CelestialBattleColumnType.Frontline:
					// Move Combat Unit from the Engaged Combat Unit Pool to the Unengaged Combat Unit Pool within their Celestial Unit Instance
					array_delete(combat_unit_instance.unit_instance.frontline_combat_unit_engaged, array_get_index(combat_unit_instance.unit_instance.frontline_combat_unit_engaged, combat_unit_instance), 1);
					array_push(combat_unit_instance.unit_instance.frontline_combat_unit_unengaged, combat_unit_instance);
					combat_unit_instance.unit_instance.frontline_combat_unit_unengaged_count[array_get_index(combat_unit_instance.unit_instance.frontline_combat_unit_type, combat_unit_instance.combat_unit_type)] += 1;
					
					// Calculate Battle Available Slot and add the Available Slot Index back to its Available Slot Pool
					var temp_frontline_combat_grid_available_slot_a = (CelestialBattleCombatGridRows * combat_unit_instance.combat_grid_column) + combat_unit_instance.combat_grid_row;
					array_push(battle_instance.battle_frontline_available_slots_a, temp_frontline_combat_grid_available_slot_a);
					
					// Increment Battle Available Slots Count
					battle_instance.battle_frontline_available_slots_count_a++;
					
					// Check if Combat Unit has been indexed in the Celestial Battle's Frontline Combat Units Array
					var temp_combat_unit_frontline_a_index = array_get_index(battle_instance.battle_frontline_combat_units_a, combat_unit_instance);
					
					if (temp_combat_unit_frontline_a_index != -1)
					{
						// Remove Combat Unit from Celestial Battle's Frontline Combat Units Array
						array_delete(battle_instance.battle_frontline_combat_units_a, temp_combat_unit_frontline_a_index, 1);
					}
					break;
				case CelestialBattleColumnType.Midline:
					// Move Combat Unit from the Engaged Combat Unit Pool to the Unengaged Combat Unit Pool within their Celestial Unit Instance
					array_delete(combat_unit_instance.unit_instance.midline_combat_unit_engaged, array_get_index(combat_unit_instance.unit_instance.midline_combat_unit_engaged, combat_unit_instance), 1);
					array_push(combat_unit_instance.unit_instance.midline_combat_unit_unengaged, combat_unit_instance);
					combat_unit_instance.unit_instance.midline_combat_unit_unengaged_count[array_get_index(combat_unit_instance.unit_instance.midline_combat_unit_type, combat_unit_instance.combat_unit_type)] += 1;
					
					// Calculate Battle Available Slot and add the Available Slot Index back to its Available Slot Pool
					var temp_midline_combat_grid_available_slot_a = (CelestialBattleCombatGridRows * combat_unit_instance.combat_grid_column) + combat_unit_instance.combat_grid_row;
					array_push(battle_instance.battle_midline_available_slots_a, temp_midline_combat_grid_available_slot_a);
					
					// Increment Battle Available Slots Count
					battle_instance.battle_midline_available_slots_count_a++;
					
					// Check if Combat Unit has been indexed in the Celestial Battle's Midline Combat Units Array
					var temp_combat_unit_midline_a_index = array_get_index(battle_instance.battle_midline_combat_units_a, combat_unit_instance);
					
					if (temp_combat_unit_midline_a_index != -1)
					{
						// Remove Combat Unit from Celestial Battle's Midline Combat Units Array
						array_delete(battle_instance.battle_midline_combat_units_a, temp_combat_unit_midline_a_index, 1);
					}
					break;
				case CelestialBattleColumnType.Backline:
					// Move Combat Unit from the Engaged Combat Unit Pool to the Unengaged Combat Unit Pool within their Celestial Unit Instance
					array_delete(combat_unit_instance.unit_instance.backline_combat_unit_engaged, array_get_index(combat_unit_instance.unit_instance.backline_combat_unit_engaged, combat_unit_instance), 1);
					array_push(combat_unit_instance.unit_instance.backline_combat_unit_unengaged, combat_unit_instance);
					combat_unit_instance.unit_instance.backline_combat_unit_unengaged_count[array_get_index(combat_unit_instance.unit_instance.backline_combat_unit_type, combat_unit_instance.combat_unit_type)] += 1;
					
					// Calculate Battle Available Slot and add the Available Slot Index back to its Available Slot Pool
					var temp_backline_combat_grid_available_slot_a = (CelestialBattleCombatGridRows * combat_unit_instance.combat_grid_column) + combat_unit_instance.combat_grid_row;
					array_push(battle_instance.battle_backline_available_slots_a, temp_backline_combat_grid_available_slot_a);
					
					// Increment Battle Available Slots Count
					battle_instance.battle_backline_available_slots_count_a++;
					
					// Check if Combat Unit has been indexed in the Celestial Battle's Backline Combat Units Array
					var temp_combat_unit_backline_a_index = array_get_index(battle_instance.battle_backline_combat_units_a, combat_unit_instance);
					
					if (temp_combat_unit_backline_a_index != -1)
					{
						// Remove Combat Unit from Celestial Battle's Backline Combat Units Array
						array_delete(battle_instance.battle_backline_combat_units_a, temp_combat_unit_backline_a_index, 1);
					}
					break;
			}
			
			// Check if Combat Unit exists within the Celestial Battle's Combat Grid Instances Array
			var temp_combat_unit_combat_grid_instances_a_index = array_get_index(battle_instance.battle_combat_grid_instances_a[combat_unit_instance.combat_grid_column], combat_unit_instance);
			
			if (temp_combat_unit_combat_grid_instances_a_index != -1)
			{
				// Remove Combat Unit from Celestial Battle's Combat Grid
				array_set(array_get(battle_instance.battle_combat_grid_a, combat_unit_instance.combat_grid_column), combat_unit_instance.combat_grid_row, noone);
				
				// Remove Combat Unit from Celestial Battle's Combat Grid Instances Array
				array_delete(battle_instance.battle_combat_grid_instances_a[combat_unit_instance.combat_grid_column], temp_combat_unit_combat_grid_instances_a_index, 1);
			}
			
			// Remove Combat Unit from Celestial Battle's Left Combat Units Pool
			array_delete(battle_instance.battle_combat_units_a, array_get_index(battle_instance.battle_combat_units_a, combat_unit_instance), 1);
			break;
		case CelestialBattleCombatGridSide.Right:
			// Remove Combat Unit Instance from Celestial Battle's Combat Column Type Arrays
			switch (global.celestial_combat_units[combat_unit_instance.combat_unit_type].unit_combat_column_type)
			{
				case CelestialBattleColumnType.Frontline:
					// Move Combat Unit from the Engaged Combat Unit Pool to the Unengaged Combat Unit Pool within their Celestial Unit Instance
					array_delete(combat_unit_instance.unit_instance.frontline_combat_unit_engaged, array_get_index(combat_unit_instance.unit_instance.frontline_combat_unit_engaged, combat_unit_instance), 1);
					array_push(combat_unit_instance.unit_instance.frontline_combat_unit_unengaged, combat_unit_instance);
					combat_unit_instance.unit_instance.frontline_combat_unit_unengaged_count[array_get_index(combat_unit_instance.unit_instance.frontline_combat_unit_type, combat_unit_instance.combat_unit_type)] += 1;
					
					// Calculate Battle Available Slot and add the Available Slot Index back to its Available Slot Pool
					var temp_frontline_combat_grid_available_slot_b = (CelestialBattleCombatGridRows * combat_unit_instance.combat_grid_column) + combat_unit_instance.combat_grid_row;
					array_push(battle_instance.battle_frontline_available_slots_b, temp_frontline_combat_grid_available_slot_b);
					
					// Increment Battle Available Slots Count
					battle_instance.battle_frontline_available_slots_count_b++;
					
					// Check if Combat Unit has been indexed in the Celestial Battle's Frontline Combat Units Array
					var temp_combat_unit_frontline_b_index = array_get_index(battle_instance.battle_frontline_combat_units_b, combat_unit_instance);
					
					if (temp_combat_unit_frontline_b_index != -1)
					{
						// Remove Combat Unit from Celestial Battle's Frontline Combat Units Array
						array_delete(battle_instance.battle_frontline_combat_units_b, temp_combat_unit_frontline_b_index, 1);
					}
					break;
				case CelestialBattleColumnType.Midline:
					// Move Combat Unit from the Engaged Combat Unit Pool to the Unengaged Combat Unit Pool within their Celestial Unit Instance
					array_delete(combat_unit_instance.unit_instance.midline_combat_unit_engaged, array_get_index(combat_unit_instance.unit_instance.midline_combat_unit_engaged, combat_unit_instance), 1);
					array_push(combat_unit_instance.unit_instance.midline_combat_unit_unengaged, combat_unit_instance);
					combat_unit_instance.unit_instance.midline_combat_unit_unengaged_count[array_get_index(combat_unit_instance.unit_instance.midline_combat_unit_type, combat_unit_instance.combat_unit_type)] += 1;
					
					// Calculate Battle Available Slot and add the Available Slot Index back to its Available Slot Pool
					var temp_midline_combat_grid_available_slot_b = (CelestialBattleCombatGridRows * combat_unit_instance.combat_grid_column) + combat_unit_instance.combat_grid_row;
					array_push(battle_instance.battle_midline_available_slots_b, temp_midline_combat_grid_available_slot_b);
					
					// Increment Battle Available Slots Count
					battle_instance.battle_midline_available_slots_count_b++;
					
					// Check if Combat Unit has been indexed in the Celestial Battle's Midline Combat Units Array
					var temp_combat_unit_midline_b_index = array_get_index(battle_instance.battle_midline_combat_units_b, combat_unit_instance);
					
					if (temp_combat_unit_midline_b_index != -1)
					{
						// Remove Combat Unit from Celestial Battle's Midline Combat Units Array
						array_delete(battle_instance.battle_midline_combat_units_b, temp_combat_unit_midline_b_index, 1);
					}
					break;
				case CelestialBattleColumnType.Backline:
					// Move Combat Unit from the Engaged Combat Unit Pool to the Unengaged Combat Unit Pool within their Celestial Unit Instance
					array_delete(combat_unit_instance.unit_instance.backline_combat_unit_engaged, array_get_index(combat_unit_instance.unit_instance.backline_combat_unit_engaged, combat_unit_instance), 1);
					array_push(combat_unit_instance.unit_instance.backline_combat_unit_unengaged, combat_unit_instance);
					combat_unit_instance.unit_instance.backline_combat_unit_unengaged_count[array_get_index(combat_unit_instance.unit_instance.backline_combat_unit_type, combat_unit_instance.combat_unit_type)] += 1;
					
					// Calculate Battle Available Slot and add the Available Slot Index back to its Available Slot Pool
					var temp_backline_combat_grid_available_slot_b = (CelestialBattleCombatGridRows * combat_unit_instance.combat_grid_column) + combat_unit_instance.combat_grid_row;
					array_push(battle_instance.battle_backline_available_slots_b, temp_backline_combat_grid_available_slot_b);
					
					// Increment Battle Available Slots Count
					battle_instance.battle_backline_available_slots_count_b++;
					
					// Check if Combat Unit has been indexed in the Celestial Battle's Backline Combat Units Array
					var temp_combat_unit_backline_b_index = array_get_index(battle_instance.battle_backline_combat_units_b, combat_unit_instance);
					
					if (temp_combat_unit_backline_b_index != -1)
					{
						// Remove Combat Unit from Celestial Battle's Backline Combat Units Array
						array_delete(battle_instance.battle_backline_combat_units_b, temp_combat_unit_backline_b_index, 1);
					}
					break;
			}
			
			// Check if Combat Unit exists within the Celestial Battle's Combat Grid Instances Array
			var temp_combat_unit_combat_grid_instances_b_index = array_get_index(battle_instance.battle_combat_grid_instances_b[combat_unit_instance.combat_grid_column], combat_unit_instance);
			
			if (temp_combat_unit_combat_grid_instances_b_index != -1)
			{
				// Remove Combat Unit from Celestial Battle's Combat Grid
				array_set(array_get(battle_instance.battle_combat_grid_b, combat_unit_instance.combat_grid_column), combat_unit_instance.combat_grid_row, noone);
				
				// Remove Combat Unit from Celestial Battle's Combat Grid Instances Array
				array_delete(battle_instance.battle_combat_grid_instances_b[combat_unit_instance.combat_grid_column], temp_combat_unit_combat_grid_instances_b_index, 1);
			}
			
			// Remove Combat Unit from Celestial Battle's Left Combat Units Pool
			array_delete(battle_instance.battle_combat_units_b, array_get_index(battle_instance.battle_combat_units_b, combat_unit_instance), 1);
			break;
	}
	
	// Reset Combat Unit's Combat Grid Variables
	combat_unit_instance.combat_grid_side = CelestialBattleCombatGridSide.None;
	combat_unit_instance.combat_grid_column = -1;
	combat_unit_instance.combat_grid_row = -1;
	combat_unit_instance.combat_grid_tile = -1;
	
	// Reset Combat Unit's Battle Instance Variable
	combat_unit_instance.battle_instance = noone;
	
	// Increment the Combat Unit's Celestial Unit Unengaged Combat Units Count
	combat_unit_instance.unit_instance.combat_unit_unengaged_count++;
}

/// @function celestial_battle_reset_combat_unit(combat_unit_instance);
/// @description Resets a Combat Unit Instance's Celestial Battle behaviour and variables, intended to be used on Combat Units being added to a new Celestial Battle
/// @param {real:Id.Instance<oCelestialCombatUnit>} combat_unit_instance The Combat Unit Instance that will have its Celestial Battle behaviour and variables reset
function celestial_battle_reset_combat_unit(combat_unit_instance)
{
	// Reset Combat Unit Instance's Combat Action Behaviour
	combat_unit_instance.combat_unit_action_type = CelestialCombatUnitActionType.None;
	combat_unit_instance.combat_unit_action_time = 0;
	combat_unit_instance.combat_unit_action_count = -1;
	combat_unit_instance.combat_unit_action_exhaustion = -1;
	combat_unit_instance.combat_unit_action_duration = -1;
	
	// Reset Combat Unit Instance's Combat Action Target Variables
	combat_unit_instance.combat_unit_action_target_inst = noone;
	combat_unit_instance.combat_unit_action_target_combat_grid_side = CelestialBattleCombatGridSide.None;
	combat_unit_instance.combat_unit_action_target_combat_grid_column = -1;
	combat_unit_instance.combat_unit_action_target_combat_grid_row = -1;
	
	// Randomize Combat Unit Instance's Position Offset
	combat_unit_instance.random_offset_x = irandom_range(-3, 3);
	combat_unit_instance.random_offset_y = irandom_range(-1, 3);
	
	// Reset Combat Unit Instance's Animation State
	combat_unit_instance.animation_state = CelestialCombatUnitAnimationState.EntryDelayed;
	
	// Reset Combat Unit Instance's Draw Variables
	combat_unit_instance.draw_alpha = 0;
	
	// Reset Combat Unit Instance's Combat Entry Variables
	combat_unit_instance.combat_entered_delay_duration = random(100);
	combat_unit_instance.combat_entry_animation_value = 0;
}

/// @function celestial_battle_combat_unit_enter(battle_instance, combat_unit_instance);
/// @description Performs a Combat Unit Instance's Enter Behaviour during a Battle, allowing them to participate in Combat and to be targeted as a Combatant
/// @param {real:Id.Instance<oCelestialBattle>} battle_instance The Celestial Battle Instance the given Combat Unit Instance will be entering
/// @param {real:Id.Instance<oCelestialCombatUnit>} combat_unit_instance The Combat Unit Instance to add to the given Celestial Battle Instance's Combat Encounter
function celestial_battle_combat_unit_enter(battle_instance, combat_unit_instance)
{
	// Check Combat Unit's Grid Direction
	switch (combat_unit_instance.combat_grid_side)
	{
		case CelestialBattleCombatGridSide.Left:
			// Add Combat Unit Instance from Celestial Battle's Combat Column Type Arrays
			switch (global.celestial_combat_units[combat_unit_instance.combat_unit_type].unit_combat_column_type)
			{
				case CelestialBattleColumnType.Frontline:
					// Add Combat Unit to Battle's Frontline Combat Unit Pools
					array_push(battle_instance.battle_frontline_combat_units_a, combat_unit_instance);
					break;
				case CelestialBattleColumnType.Midline:
					// Add Combat Unit to Battle's Midline Combat Unit Pools
					array_push(battle_instance.battle_midline_combat_units_a, combat_unit_instance);
					break;
				case CelestialBattleColumnType.Backline:
					// Add Combat Unit to Battle's Backline Combat Unit Pools
					array_push(battle_instance.battle_backline_combat_units_a, combat_unit_instance);
					break;
			}
			
			// Place Selected Combat Unit in the Combat Grid's Available Slot
			array_set(array_get(battle_instance.battle_combat_grid_a, combat_unit_instance.combat_grid_column), combat_unit_instance.combat_grid_row, combat_unit_instance);
			array_push(array_get(battle_instance.battle_combat_grid_instances_a, combat_unit_instance.combat_grid_column), combat_unit_instance);
			break;
		case CelestialBattleCombatGridSide.Right:
			// Add Combat Unit Instance from Celestial Battle's Combat Column Type Arrays
			switch (global.celestial_combat_units[combat_unit_instance.combat_unit_type].unit_combat_column_type)
			{
				case CelestialBattleColumnType.Frontline:
					// Add Combat Unit to Battle's Frontline Combat Unit Pools
					array_push(battle_instance.battle_frontline_combat_units_b, combat_unit_instance);
					break;
				case CelestialBattleColumnType.Midline:
					// Add Combat Unit to Battle's Midline Combat Unit Pools
					array_push(battle_instance.battle_midline_combat_units_b, combat_unit_instance);
					break;
				case CelestialBattleColumnType.Backline:
					// Add Combat Unit to Battle's Backline Combat Unit Pools
					array_push(battle_instance.battle_backline_combat_units_b, combat_unit_instance);
					break;
			}
			
			// Place Selected Combat Unit in the Combat Grid's Available Slot
			array_set(array_get(battle_instance.battle_combat_grid_b, combat_unit_instance.combat_grid_column), combat_unit_instance.combat_grid_row, combat_unit_instance);
			array_push(array_get(battle_instance.battle_combat_grid_instances_b, combat_unit_instance.combat_grid_column), combat_unit_instance);
			break;
	}
	
	// Update Combat Unit Instance's Animation State
	combat_unit_instance.animation_state = CelestialCombatUnitAnimationState.Entry;
	
	// Update Combat Unit Instance's Combat Entry Variables
	combat_unit_instance.combat_entry_animation_value = 0;
	
	// Reset Combat Unit Instance's Draw Variables
	combat_unit_instance.draw_alpha = 0;
	combat_unit_instance.draw_image_index_value = random(20);
	
	// Combat Unit Equip Item from Inventory Behaviour
	var temp_combat_unit_inventory_count = array_length(combat_unit_instance.item_inventory);
	var temp_combat_unit_inventory_index = 0;
	
	repeat (temp_combat_unit_inventory_count)
	{
		// Check Inventory Slot for Item
		if (combat_unit_instance.item_inventory[temp_combat_unit_inventory_index].item != -1)
		{
			// Equip Item from first Inventory Slot with an Item
			celestial_combat_unit_equip_item(combat_unit_instance, temp_combat_unit_inventory_index);
			
			// Exit Loop
			break;
		}
		
		// Increment Combat Unit Inventory Index
		temp_combat_unit_inventory_index++;
	}
	
	// Set Combat Unit's Exhuastion
	combat_unit_instance.combat_unit_action_exhaustion = random_range(4, 12);
	
	// Reset Combat Unit Instance's Item Variables
	combat_unit_instance.item_aim = 0;
	
	combat_unit_instance.item_angle = 270;
	
	combat_unit_instance.item_target_x = 0;
	combat_unit_instance.item_target_y = 0;
	combat_unit_instance.item_target_angle = 90 + (combat_unit_instance.draw_xscale * -90);
	
	combat_unit_instance.item_angle_recoil = 0;
	combat_unit_instance.item_horizontal_recoil = 0;
	combat_unit_instance.item_vertical_recoil = 0;
	
	combat_unit_instance.item_muzzle_offset_x = 0;
	combat_unit_instance.item_muzzle_offset_y = 0;
	
	combat_unit_instance.item_muzzle_emission_duration = 0;
	combat_unit_instance.item_muzzle_emission_image_index = 0;
}

/// @function celestial_battle_combat_unit_leave(battle_instance, combat_unit_instance);
/// @description Performs a Combat Unit Instance's Leave Animation during a Battle
/// @param {real:Id.Instance<oCelestialBattle>} battle_instance The Celestial Battle Instance the given Combat Unit Instance will be performing their Leave Animation within
/// @param {real:Id.Instance<oCelestialCombatUnit>} combat_unit_instance The Combat Unit Instance to perform their Leave Animation
function celestial_battle_combat_unit_leave(battle_instance, combat_unit_instance)
{
	// Check if Combat Unit Instance is already performing their Exit Animation State
	if (combat_unit_instance.animation_state == CelestialCombatUnitAnimationState.Exit)
	{
		// Combat Unit Instance cannot "leave twice" - Early Return
		return;
	}
	
	// Duplicate Combat Unit Instance with Combat Unit Leave Instance
	var temp_combat_unit_leave_inst = instance_create_depth(0, 0, 0, oCelestialCombatUnit);
	
	with (temp_combat_unit_leave_inst)
	{
		// Duplicate Combat Unit Properties
		combat_unit_type = combat_unit_instance.combat_unit_type;
		
		// Duplicate Combat Grid Variables
		combat_grid_side = combat_unit_instance.combat_grid_side;
		
		combat_grid_column = combat_unit_instance.combat_grid_column;
		combat_grid_row = combat_unit_instance.combat_grid_row;
		
		combat_grid_tile = combat_unit_instance.combat_grid_tile;
		
		// Duplicate Inventory Variables
		celestial_combat_unit_duplicate_equipped_item(combat_unit_instance, temp_combat_unit_leave_inst);
		
		// Duplicate Item Variables
		item_aim = combat_unit_instance.item_aim;
		
		item_angle = combat_unit_instance.item_angle;
		
		item_angle_recoil = combat_unit_instance.item_angle_recoil;
		item_horizontal_recoil = combat_unit_instance.item_horizontal_recoil;
		item_vertical_recoil = combat_unit_instance.item_vertical_recoil;
		
		// Duplicate Position Variables
		random_offset_x = combat_unit_instance.random_offset_x;
		random_offset_y = combat_unit_instance.random_offset_y;
		
		// Duplicate Draw Variables
		draw_image_index_value = combat_unit_instance.draw_image_index_value;
		draw_xscale = combat_unit_instance.draw_xscale;
		draw_alpha = combat_unit_instance.draw_alpha;
	}
	
	// Update Combat Unit Leave Instance's Faction Color with Combat Unit Instance's Color
	temp_combat_unit_leave_inst.image_blend = combat_unit_instance.image_blend;
	
	// Add Selected Combat Unit to Battle's Combat Units Pool
	array_insert(battle_instance.battle_combat_units, 0, temp_combat_unit_leave_inst);
	
	// Animation Variables
	temp_combat_unit_leave_inst.animation_state = CelestialCombatUnitAnimationState.Exit;
	
	// Combat Entry & Exit Variables
	temp_combat_unit_leave_inst.combat_exiting_delay_duration = random(40);
}
#endregion

