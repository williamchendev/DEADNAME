// Weapon Type Enums
enum WeaponType
{
    Default,
    DefaultMelee,
    DefaultFirearm,
    BoltActionFirearm
}

// Weapon Pack Enums
enum WeaponPack
{
    Default,
    Corso,
    SMG
}

// Create Weapon Function
/// create_weapon_from_weapon_pack(weapon_pack);
/// @description Creates a WeaponClass from the given Weapon Pack
/// @param {number} weapon_pack 
/// @returns {WeaponClass} returns true if location is empty of solids and the list of platform instances
function create_weapon_from_weapon_pack(weapon_pack) 
{
    var temp_weapon_class = noone;
    
	switch (global.weapon_packs[weapon_pack].weapon_type)
	{
	    case WeaponType.DefaultFirearm:
	    case WeaponType.BoltActionFirearm:
	        temp_weapon_class = NEW(FirearmClass);
	        break;
	    default:
	        temp_weapon_class = NEW(WeaponClass);
	        break;
	}
	
	temp_weapon_class.init_weapon_pack(weapon_pack);
	return temp_weapon_class;
}

// Default Weapon Pack
global.weapon_packs[WeaponPack.Default] =
{
    // Weapon Type
    weapon_type: WeaponType.DefaultFirearm,
    
    // Diffuse Map, Normal Map, MetallicRoughness Map, and Emissive Map
    weapon_sprite: sArkov_FAL,
    weapon_normalmap: sArkov_FAL_NormalMap,
    weapon_metallicroughnessmap: noone,
    weapon_emissivemap: noone,
    
    // Weapon PBR Settings
    metallic: false,
    roughness: 0.2,
    emissive: 0,
    
    // Weapon Ammo
    firearm_max_ammo_capacity: 15,
    firearm_reload_individual_rounds: false,
    
    // Weapon Properties
    firearm_attack_delay: 10,
    
    // Weapon FX
    firearm_muzzle_smoke_object: oFirearm_MuzzleSmoke_Medium,
    firearm_muzzle_smoke_min: 4,
    firearm_muzzle_smoke_max: 6,
    
    firearm_muzzle_flare_object: oFirearm_MuzzleFlare_Medium,
    
    // Weapon Recoil
    firearm_recoil_recovery_delay: 2,
    
    firearm_random_recoil_horizontal_min: -2,
    firearm_random_recoil_horizontal_max: -0.5,
    firearm_total_recoil_horizontal: 12,
    
    firearm_random_recoil_vertical_min: -0.2,
    firearm_random_recoil_vertical_max: -0.1,
    firearm_total_recoil_vertical: 12,
    
    firearm_random_recoil_angle_min: 0,
    firearm_random_recoil_angle_max: 10,
    firearm_total_recoil_angle: 8,
    
    // Weapon Bolt Operation
    firearm_bolt_handle_position_x: 0,
    firearm_bolt_handle_position_y: 0,
    
    firearm_bolt_handle_charge_offset_x: 0,
    firearm_bolt_handle_charge_offset_y: 0,
    
    // Weapon Hand Positions
    weapon_hand_position_primary_x: 5,
    weapon_hand_position_primary_y: 1,
    
    weapon_hand_position_offhand_x: 19,
    weapon_hand_position_offhand_y: 0,
    
    // Weapon Reload Positions
    firearm_reload_x: 10,
	firearm_reload_y: 2,

	firearm_reload_offset_x: 0,
	firearm_reload_offset_y: 6,
};

// Corso Bolt-Action Rifle Weapon Pack
global.weapon_packs[WeaponPack.Corso] =
{
    // Weapon Type
    weapon_type: WeaponType.BoltActionFirearm,
    
    // Diffuse Map, Normal Map, MetallicRoughness Map, and Emissive Map
    weapon_sprite: sArkov_CorsoRifle,
    weapon_normalmap: sArkov_CorsoRifle_NormalMap,
    weapon_metallicroughnessmap: noone,
    weapon_emissivemap: noone,
    
    // Weapon PBR Settings
    metallic: false,
    roughness: 0.2,
    emissive: 0,
    
    // Weapon Ammo
    firearm_max_ammo_capacity: 5,
    firearm_reload_individual_rounds: true,
    
    // Weapon Properties
    firearm_attack_delay: 14,
    firearm_attack_distance: 600,
    firearm_attack_hit_percentage: 0.5,
    
    firearm_attack_damage: 3,
    firearm_attack_luck_damage: 0.7,
    
    firearm_attack_impulse_power: 50,
    
    // Weapon FX
    firearm_muzzle_smoke_object: oFirearm_MuzzleSmoke_Medium,
    firearm_muzzle_smoke_min: 4,
    firearm_muzzle_smoke_max: 6,
    
    firearm_muzzle_flare_object: oFirearm_MuzzleFlare_Medium,
    
    firearm_smoke_trail_object: oFirearm_SmokeTrail_Medium,
    
    // Weapon Safety Angles
    firearm_idle_safety_angle: -15,
    firearm_moving_safety_angle: -45,
    firearm_reload_safety_angle: 15,
    
    // Weapon Recoil
    firearm_recoil_recovery_delay: 9,
    
    firearm_random_recoil_horizontal_min: -4.5,
    firearm_random_recoil_horizontal_max: -3,
    firearm_total_recoil_horizontal: 4.5,
    
    firearm_random_recoil_vertical_min: -0.2,
    firearm_random_recoil_vertical_max: -0.05,
    firearm_total_recoil_vertical: 3,
    
    firearm_random_recoil_angle_min: 2,
    firearm_random_recoil_angle_max: 3,
    firearm_total_recoil_angle: 13,
    
    // Weapon Bolt Operation
    firearm_bolt_handle_position_x: 3,
    firearm_bolt_handle_position_y: 2,
    
    firearm_bolt_handle_charge_offset_x: -6,
    firearm_bolt_handle_charge_offset_y: -2,
    
    // Weapon Hand Positions
    weapon_hand_position_primary_x: 4,
    weapon_hand_position_primary_y: 3,

    weapon_hand_position_offhand_x: 17,
    weapon_hand_position_offhand_y: 1,
    
    // Weapon Reload Positions
    firearm_reload_x: 6,
	firearm_reload_y: -1,

	firearm_reload_offset_x: 0,
	firearm_reload_offset_y: -7,
	
	// Weapon Muzzle Positions
	firearm_muzzle_x: 29,
	firearm_muzzle_y: -1,
};

// SMG Weapon Pack
global.weapon_packs[WeaponPack.SMG] =
{
    // Weapon Type
    weapon_type: WeaponType.DefaultFirearm,
    
    // Diffuse Map, Normal Map, MetallicRoughness Map, and Emissive Map
    weapon_sprite: sBlackMarket_OilerSubmachineGun,
    weapon_normalmap: sBlackMarket_OilerSubmachineGun_NormalMap,
    weapon_metallicroughnessmap: noone,
    weapon_emissivemap: noone,
    
    // Weapon PBR Settings
    metallic: false,
    roughness: 0.2,
    emissive: 0,
    
    // Weapon Ammo
    firearm_max_ammo_capacity: 16,
    firearm_reload_individual_rounds: false,
    
    // Weapon Properties
    firearm_attack_delay: 5,
    firearm_attack_distance: 400,
    firearm_attack_hit_percentage: 0.25,
    
    firearm_attack_damage: 2,
    firearm_attack_luck_damage: 0.2,
    
    firearm_attack_impulse_power: 35,
    
    // Weapon FX
    firearm_muzzle_smoke_object: oFirearm_MuzzleSmoke_Small,
    firearm_muzzle_smoke_min: 1,
    firearm_muzzle_smoke_max: 2,
    
    firearm_muzzle_flare_object: oFirearm_MuzzleFlare_Small,
    
    firearm_smoke_trail_object: oFirearm_SmokeTrail_Small,
    
    // Weapon Safety Angles
    firearm_idle_safety_angle: -10,
    firearm_moving_safety_angle: -25,
    firearm_reload_safety_angle: 15,
    
    // Weapon Recoil
    firearm_recoil_recovery_delay: 2,
    
    firearm_random_recoil_horizontal_min: -6,
    firearm_random_recoil_horizontal_max: -2,
    firearm_total_recoil_horizontal: 6,
    
    firearm_random_recoil_vertical_min: -0.25,
    firearm_random_recoil_vertical_max: 1.6,
    firearm_total_recoil_vertical: 2,
    
    firearm_random_recoil_angle_min: -2,
    firearm_random_recoil_angle_max: 6,
    firearm_total_recoil_angle: 8,
    
    // Weapon Bolt Operation
    firearm_bolt_handle_position_x: 0,
    firearm_bolt_handle_position_y: 0,
    
    firearm_bolt_handle_charge_offset_x: 0,
    firearm_bolt_handle_charge_offset_y: 0,
    
    // Weapon Hand Positions
    weapon_hand_position_primary_x: 2,
    weapon_hand_position_primary_y: 3,

    weapon_hand_position_offhand_x: 12,
    weapon_hand_position_offhand_y: 1,
    
    // Weapon Reload Positions
    firearm_reload_x: 7,
	firearm_reload_y: 2,

	firearm_reload_offset_x: 0,
	firearm_reload_offset_y: 6,
	
	// Weapon Muzzle Positions
	firearm_muzzle_x: 18,
	firearm_muzzle_y: 0,
};