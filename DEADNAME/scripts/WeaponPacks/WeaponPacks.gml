// Weapon Type Enums
enum WeaponType
{
    Default,
    DefaultMelee,
    DefaultFirearm
}

// Weapon Pack Enums
enum WeaponPack
{
    Default,
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
    
    // Sprite & NormalMap
    weapon_sprite: sArkov_CorsoRifle,
    weapon_normalmap: sArkov_CorsoRifle_NormalMap,
    
    // Weapon Properties
    firearm_max_ammo: 5,
    
    firearm_cycle_delay: 10,
    
    // Weapon Recoil
    firearm_reload_recovery_delay: 2,
    
    firearm_random_recoil_horizontal_min: -2,
    firearm_random_recoil_horizontal_max: -0.5,
    firearm_total_recoil_horizontal: 12,
    
    firearm_random_recoil_vertical_min: -0.2,
    firearm_random_recoil_vertical_max: -0.1,
    firearm_total_recoil_vertical: 12,
    
    firearm_random_recoil_angle_min: 4,
    firearm_random_recoil_angle_max: 4,
    firearm_total_recoil_angle: 20,
    
    // Weapon Positions
    weapon_hand_position_trigger_x: 4,
    weapon_hand_position_trigger_y: 3,

    weapon_hand_position_offhand_x: 17,
    weapon_hand_position_offhand_y: 1,
}

// SMG Weapon Pack
global.weapon_packs[WeaponPack.SMG] =
{
    // Weapon Type
    weapon_type: WeaponType.DefaultFirearm,
    
    // Sprite & NormalMap
    weapon_sprite: sArkov_CorsoRifle,
    weapon_normalmap: sArkov_CorsoRifle_NormalMap,
}