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