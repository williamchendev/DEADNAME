// Unit Animation States
enum UnitAnimationState
{
    Idle,
    Walking,
    Jumping,
    Aiming,
    AimWalking
}

enum UnitEquipmentAnimationState
{
    None,
    Firearm,
    FirearmReload
}

enum UnitFirearmReloadAnimationState
{
	Reload_End,
	ReloadBoltHandle_End,
	Reload_MovePrimaryHandToUnitInventory,
	Reload_InventoryHandFumbleAnimation,
	Reload_MovePrimaryHandToFirearmReloadPosition,
	ReloadMagazine_MagazineInsertAnimation,
	ReloadMagazine_MagazineHandFumbleAnimation,
	ReloadIndividualRounds_MovePrimaryHandToFirearmReloadPosition,
	ReloadIndividualRounds_MovePrimaryHandToFirearmReloadOffsetPosition,
	ReloadIndividualRounds_IndividualRoundHandFumbleAnimation,
	ChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition,
	ChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition,
	ChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle,
	ChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle,
	ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition,
	ReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition,
	ReloadChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle,
	ReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle,
	InterruptReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleOpenChamberPosition,
	InterruptReloadChargeBoltHandle_MovePrimaryHandToFirearmBoltHandleClosedChamberPosition,
	InterruptReloadChargeBoltHandle_PrimaryHandFirearmPullBackwardBoltHandle,
	InterruptReloadChargeBoltHandle_PrimaryHandFirearmPushForwardBoltHandle,
}

// Unit Character Pack Enums
enum UnitPack
{
    Default = 0,
    MoralistWilliam = 1,
    Wolf = 2,
    Director = 3,
    Knives = 4,
    Martyr = 5,
    NorthernBrigadeSoldier = 6,
    NorthernBrigadeOfficer = 7
}

// Default Unit Pack
global.unit_packs[UnitPack.Default] = 
{
	// Animation Sprites
	idle_sprite: sWilliam_CapitalLoyalist_Idle,
	walk_sprite: sWilliam_CapitalLoyalist_Run,
	jump_sprite: sWilliam_CapitalLoyalist_Jump,
	aim_sprite: sWilliam_CapitalLoyalist_Aim,
	aim_walk_sprite: sWilliam_CapitalLoyalist_AimWalk,
	
	// Animation NormalMaps
	idle_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_Idle, sWilliam_CapitalLoyalist_Idle_NormalMap),
	walk_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_Run, sWilliam_CapitalLoyalist_Run_NormalMap),
	jump_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_Jump, sWilliam_CapitalLoyalist_Jump_NormalMap),
	aim_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_Aim, sWilliam_CapitalLoyalist_Aim_NormalMap),
	aim_walk_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_AimWalk, sWilliam_CapitalLoyalist_AimWalk_NormalMap),
	
	// Bodypart Sprites
	ragdoll_head_sprite: sWilliam_CapitalLoyalist_Head,
	ragdoll_arm_left_sprite: sWilliam_CapitalLoyalist_Arms,
	ragdoll_arm_right_sprite: sWilliam_CapitalLoyalist_Arms,
	ragdoll_chest_top_sprite: sWilliam_CapitalLoyalist_ChestTop,
	ragdoll_chest_bot_sprite: sWilliam_CapitalLoyalist_ChestBot,
	ragdoll_leg_left_sprite: sWilliam_CapitalLoyalist_LeftLeg,
	ragdoll_leg_right_sprite: sWilliam_CapitalLoyalist_RightLeg,
	
	// Bodypart NormalMaps
	ragdoll_head_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_Head, sWilliam_CapitalLoyalist_Head_NormalMap),
	ragdoll_arm_left_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_Arms, sWilliam_CapitalLoyalist_Arms_NormalMap),
	ragdoll_arm_right_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_Arms, sWilliam_CapitalLoyalist_Arms_NormalMap),
	ragdoll_chest_top_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_ChestTop, sWilliam_CapitalLoyalist_ChestTop_NormalMap),
	ragdoll_chest_bot_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_ChestBot, sWilliam_CapitalLoyalist_ChestBot_NormalMap),
	ragdoll_leg_left_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_LeftLeg, sWilliam_CapitalLoyalist_LeftLeg_NormalMap),
	ragdoll_leg_right_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_RightLeg, sWilliam_CapitalLoyalist_RightLeg_NormalMap),
	
	// Limb & Equipment Positions
	limb_anchor_left_arm_x: -7,
	limb_anchor_left_arm_y: -35,
	
	limb_anchor_right_arm_x: 4,
	limb_anchor_right_arm_y: -35,
	
	equipment_inventory_x: -3,
	equipment_inventory_y: -28,
	
	equipment_firearm_hip_x: -2,
	equipment_firearm_hip_y: -30,
	
	equipment_firearm_aim_x: 3,
	equipment_firearm_aim_y: -40,
	
	// Limb Animation Settings
	limb_idle_animation_extension_percent: 0.95,
	limb_idle_animation_ambient_move_width: 2,
	limb_left_arm_idle_animation_angle: -10,
	limb_right_arm_idle_animation_angle: 13,
		
	limb_left_arm_walk_animation_extension_percent: 0.5,
	limb_left_arm_walk_animation_ambient_move_width: 4,
	limb_left_arm_walk_animation_ambient_move_height: 1,
	limb_left_arm_walk_animation_angle: 0,
	
	limb_right_arm_walk_animation_extension_percent: 0.6,
	limb_right_arm_walk_animation_ambient_move_width: 2,
	limb_right_arm_walk_animation_ambient_move_height: 1,
	limb_right_arm_walk_animation_angle: 30,
	
	limb_jump_animation_extension_percent: 0.95,
	limb_left_arm_jump_animation_angle: -15,
	limb_right_arm_jump_animation_angle: 18,
}

// Moralist William
global.unit_packs[UnitPack.MoralistWilliam] = 
{
	// Animation Sprites
	idle_sprite: sWilliam_CapitalLoyalist_Idle,
	walk_sprite: sWilliam_CapitalLoyalist_Run,
	jump_sprite: sWilliam_CapitalLoyalist_Jump,
	aim_sprite: sWilliam_CapitalLoyalist_Aim,
	aim_walk_sprite: sWilliam_CapitalLoyalist_AimWalk,
	
	// Animation NormalMaps
	idle_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_Idle, sWilliam_CapitalLoyalist_Idle_NormalMap),
	walk_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_Run, sWilliam_CapitalLoyalist_Run_NormalMap),
	jump_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_Jump, sWilliam_CapitalLoyalist_Jump_NormalMap),
	aim_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_Aim, sWilliam_CapitalLoyalist_Aim_NormalMap),
	aim_walk_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_AimWalk, sWilliam_CapitalLoyalist_AimWalk_NormalMap),
	
	// Bodypart Sprites
	ragdoll_head_sprite: sWilliam_CapitalLoyalist_Head,
	ragdoll_arm_left_sprite: sWilliam_CapitalLoyalist_Arms,
	ragdoll_arm_right_sprite: sWilliam_CapitalLoyalist_Arms,
	ragdoll_chest_top_sprite: sWilliam_CapitalLoyalist_ChestTop,
	ragdoll_chest_bot_sprite: sWilliam_CapitalLoyalist_ChestBot,
	ragdoll_leg_left_sprite: sWilliam_CapitalLoyalist_LeftLeg,
	ragdoll_leg_right_sprite: sWilliam_CapitalLoyalist_RightLeg,
	
	// Bodypart NormalMaps
	ragdoll_head_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_Head, sWilliam_CapitalLoyalist_Head_NormalMap),
	ragdoll_arm_left_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_Arms, sWilliam_CapitalLoyalist_Arms_NormalMap),
	ragdoll_arm_right_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_Arms, sWilliam_CapitalLoyalist_Arms_NormalMap),
	ragdoll_chest_top_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_ChestTop, sWilliam_CapitalLoyalist_ChestTop_NormalMap),
	ragdoll_chest_bot_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_ChestBot, sWilliam_CapitalLoyalist_ChestBot_NormalMap),
	ragdoll_leg_left_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_LeftLeg, sWilliam_CapitalLoyalist_LeftLeg_NormalMap),
	ragdoll_leg_right_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_RightLeg, sWilliam_CapitalLoyalist_RightLeg_NormalMap),
	
	// Limb & Equipment Positions
	limb_anchor_left_arm_x: -7,
	limb_anchor_left_arm_y: -35,
	
	limb_anchor_right_arm_x: 4,
	limb_anchor_right_arm_y: -35,
	
	equipment_inventory_x: -3,
	equipment_inventory_y: -28,
	
	equipment_firearm_hip_x: -2,
	equipment_firearm_hip_y: -30,
	
	equipment_firearm_aim_x: 3,
	equipment_firearm_aim_y: -40,
	
	// Limb Animation Settings
	limb_idle_animation_extension_percent: 0.95,
	limb_idle_animation_ambient_move_width: 2,
	limb_left_arm_idle_animation_angle: -10,
	limb_right_arm_idle_animation_angle: 13,
		
	limb_left_arm_walk_animation_extension_percent: 0.5,
	limb_left_arm_walk_animation_ambient_move_width: 4,
	limb_left_arm_walk_animation_ambient_move_height: 1,
	limb_left_arm_walk_animation_angle: 0,
	
	limb_right_arm_walk_animation_extension_percent: 0.6,
	limb_right_arm_walk_animation_ambient_move_width: 2,
	limb_right_arm_walk_animation_ambient_move_height: 1,
	limb_right_arm_walk_animation_angle: 30,
	
	limb_jump_animation_extension_percent: 0.95,
	limb_left_arm_jump_animation_angle: -15,
	limb_right_arm_jump_animation_angle: 18,
}

// Wolf
global.unit_packs[UnitPack.Wolf] = 
{
	// Animation Sprites
	idle_sprite: sWolf_Idle,
	walk_sprite: sWolf_Run,
	jump_sprite: sWolf_Jump,
	aim_sprite: sWolf_Aim,
	aim_walk_sprite: sWolf_AimWalk,
	
	// Animation NormalMaps
	idle_normalmap: spritepack_get_uvs_transformed(sWolf_Idle, sWolf_Idle_NormalMap),
	walk_normalmap: spritepack_get_uvs_transformed(sWolf_Run, sWolf_Run_NormalMap),
	jump_normalmap: spritepack_get_uvs_transformed(sWolf_Jump, sWolf_Jump_NormalMap),
	aim_normalmap: spritepack_get_uvs_transformed(sWolf_Aim, sWolf_Aim_NormalMap),
	aim_walk_normalmap: spritepack_get_uvs_transformed(sWolf_AimWalk, sWolf_AimWalk_NormalMap),
	
	// Bodypart Sprites
	ragdoll_head_sprite: sWilliam_CapitalLoyalist_Head,
	ragdoll_arm_left_sprite: sWolf_Arms,
	ragdoll_arm_right_sprite: sWolf_Arms,
	ragdoll_chest_top_sprite: sWilliam_CapitalLoyalist_ChestTop,
	ragdoll_chest_bot_sprite: sWilliam_CapitalLoyalist_ChestBot,
	ragdoll_leg_left_sprite: sWilliam_CapitalLoyalist_LeftLeg,
	ragdoll_leg_right_sprite: sWilliam_CapitalLoyalist_RightLeg,
	
	// Bodypart NormalMaps
	ragdoll_head_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_Head, sWilliam_CapitalLoyalist_Head_NormalMap),
	ragdoll_arm_left_normalmap: spritepack_get_uvs_transformed(sWolf_Arms, sWolf_Arms_NormalMap),
	ragdoll_arm_right_normalmap: spritepack_get_uvs_transformed(sWolf_Arms, sWolf_Arms_NormalMap),
	ragdoll_chest_top_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_ChestTop, sWilliam_CapitalLoyalist_ChestTop_NormalMap),
	ragdoll_chest_bot_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_ChestBot, sWilliam_CapitalLoyalist_ChestBot_NormalMap),
	ragdoll_leg_left_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_LeftLeg, sWilliam_CapitalLoyalist_LeftLeg_NormalMap),
	ragdoll_leg_right_normalmap: spritepack_get_uvs_transformed(sWilliam_CapitalLoyalist_RightLeg, sWilliam_CapitalLoyalist_RightLeg_NormalMap),
	
	// Limb & Equipment Positions
	limb_anchor_left_arm_x: -7,
	limb_anchor_left_arm_y: -34,
	
	limb_anchor_right_arm_x: 3,
	limb_anchor_right_arm_y: -34,
	
	equipment_inventory_x: -2,
	equipment_inventory_y: -22,
	
	equipment_firearm_hip_x: -6,
	equipment_firearm_hip_y: -22,
	
	equipment_firearm_aim_x: 3,
	equipment_firearm_aim_y: -29,
}

// Director
global.unit_packs[UnitPack.Director] = 
{
	// Animation Sprites
	idle_sprite: sWilliam_Director_Idle,
	walk_sprite: sWilliam_Director_Run,
	jump_sprite: sWilliam_Director_Jump,
	aim_sprite: sWilliam_Director_Aim,
	aim_walk_sprite: sWilliam_Director_AimWalk,
	
	// Animation NormalMaps
	idle_normalmap: spritepack_get_uvs_transformed(sWilliam_Director_Idle, sWilliam_Director_Idle_NormalMap),
	walk_normalmap: spritepack_get_uvs_transformed(sWilliam_Director_Run, sWilliam_Director_Run_NormalMap),
	jump_normalmap: spritepack_get_uvs_transformed(sWilliam_Director_Jump, sWilliam_Director_Jump_NormalMap),
	aim_normalmap: spritepack_get_uvs_transformed(sWilliam_Director_Aim, sWilliam_Director_Aim_NormalMap),
	aim_walk_normalmap: spritepack_get_uvs_transformed(sWilliam_Director_AimWalk, sWilliam_Director_AimWalk_NormalMap),
	
	// Bodypart Sprites
	ragdoll_head_sprite: sWilliam_Knives_Head,
	ragdoll_arm_left_sprite: sWilliam_Director_Arms,
	ragdoll_arm_right_sprite: sWilliam_Director_Arms,
	ragdoll_chest_top_sprite: sWilliam_Knives_ChestTop,
	ragdoll_chest_bot_sprite: sWilliam_Knives_ChestBot,
	ragdoll_leg_left_sprite: sWilliam_Knives_LeftLeg,
	ragdoll_leg_right_sprite: sWilliam_Knives_RightLeg,
	
	// Bodypart NormalMaps
	ragdoll_head_normalmap: spritepack_get_uvs_transformed(sWilliam_Knives_Head, sWilliam_Knives_Head_NormalMap),
	ragdoll_arm_left_normalmap: spritepack_get_uvs_transformed(sWilliam_Director_Arms, sWilliam_Director_Arms_NormalMap),
	ragdoll_arm_right_normalmap: spritepack_get_uvs_transformed(sWilliam_Director_Arms, sWilliam_Director_Arms_NormalMap),
	ragdoll_chest_top_normalmap: spritepack_get_uvs_transformed(sWilliam_Knives_ChestTop, sWilliam_Knives_ChestTop_NormalMap),
	ragdoll_chest_bot_normalmap: spritepack_get_uvs_transformed(sWilliam_Knives_ChestBot, sWilliam_Knives_ChestBot_NormalMap),
	ragdoll_leg_left_normalmap: spritepack_get_uvs_transformed(sWilliam_Knives_LeftLeg, sWilliam_Knives_LeftLeg_NormalMap),
	ragdoll_leg_right_normalmap: spritepack_get_uvs_transformed(sWilliam_Knives_RightLeg, sWilliam_Knives_RightLeg_NormalMap),
	
	// Limb & Equipment Positions
	limb_anchor_left_arm_x: -5,
	limb_anchor_left_arm_y: -37,
	
	limb_anchor_right_arm_x: 4,
	limb_anchor_right_arm_y: -35,
	
	equipment_inventory_x: -3,
	equipment_inventory_y: -28,
	
	equipment_firearm_hip_x: -2,
	equipment_firearm_hip_y: -30,
	
	equipment_firearm_aim_x: 5,
	equipment_firearm_aim_y: -41,
}

// Knives
global.unit_packs[UnitPack.Knives] = 
{
	// Animation Sprites
	idle_sprite: sWilliam_Knives_Idle,
	walk_sprite: sWilliam_Knives_Run,
	jump_sprite: sWilliam_Knives_Jump,
	aim_sprite: sWilliam_Knives_Aim,
	aim_walk_sprite: sWilliam_Knives_AimWalk,
	
	// Animation NormalMaps
	idle_normalmap: spritepack_get_uvs_transformed(sWilliam_Knives_Idle, sWilliam_Knives_Idle_NormalMap),
	walk_normalmap: spritepack_get_uvs_transformed(sWilliam_Knives_Run, sWilliam_Knives_Run_NormalMap),
	jump_normalmap: spritepack_get_uvs_transformed(sWilliam_Knives_Jump, sWilliam_Knives_Jump_NormalMap),
	aim_normalmap: spritepack_get_uvs_transformed(sWilliam_Knives_Aim, sWilliam_Knives_Aim_NormalMap),
	aim_walk_normalmap: spritepack_get_uvs_transformed(sWilliam_Knives_AimWalk, sWilliam_Knives_AimWalk_NormalMap),
	
	// Bodypart Sprites
	ragdoll_head_sprite: sWilliam_Knives_Head,
	ragdoll_arm_left_sprite: sWilliam_Knives_Arms,
	ragdoll_arm_right_sprite: sWilliam_Knives_Arms,
	ragdoll_chest_top_sprite: sWilliam_Knives_ChestTop,
	ragdoll_chest_bot_sprite: sWilliam_Knives_ChestBot,
	ragdoll_leg_left_sprite: sWilliam_Knives_LeftLeg,
	ragdoll_leg_right_sprite: sWilliam_Knives_RightLeg,
	
	// Bodypart NormalMaps
	ragdoll_head_normalmap: spritepack_get_uvs_transformed(sWilliam_Knives_Head, sWilliam_Knives_Head_NormalMap),
	ragdoll_arm_left_normalmap: spritepack_get_uvs_transformed(sWilliam_Knives_Arms, sWilliam_Knives_Arms_NormalMap),
	ragdoll_arm_right_normalmap: spritepack_get_uvs_transformed(sWilliam_Knives_Arms, sWilliam_Knives_Arms_NormalMap),
	ragdoll_chest_top_normalmap: spritepack_get_uvs_transformed(sWilliam_Knives_ChestTop, sWilliam_Knives_ChestTop_NormalMap),
	ragdoll_chest_bot_normalmap: spritepack_get_uvs_transformed(sWilliam_Knives_ChestBot, sWilliam_Knives_ChestBot_NormalMap),
	ragdoll_leg_left_normalmap: spritepack_get_uvs_transformed(sWilliam_Knives_LeftLeg, sWilliam_Knives_LeftLeg_NormalMap),
	ragdoll_leg_right_normalmap: spritepack_get_uvs_transformed(sWilliam_Knives_RightLeg, sWilliam_Knives_RightLeg_NormalMap),
	
	// Limb & Equipment Positions
	limb_anchor_left_arm_x: -5,
	limb_anchor_left_arm_y: -34,
	
	limb_anchor_right_arm_x: 5,
	limb_anchor_right_arm_y: -34,
	
	equipment_inventory_x: -5,
	equipment_inventory_y: -21,
	
	equipment_firearm_hip_x: -4,
	equipment_firearm_hip_y: -28,
	
	equipment_firearm_aim_x: 5,
	equipment_firearm_aim_y: -38,
}

// Martyr
global.unit_packs[UnitPack.Martyr] = 
{
	// Animation Sprites
	idle_sprite: sWilliamDS_Heavy_Idle,
	walk_sprite: sWilliamDS_Heavy_Run,
	jump_sprite: sWilliamDS_Heavy_Jump,
	aim_sprite: sWilliamDS_Heavy_Aim,
	aim_walk_sprite: sWilliamDS_Heavy_AimWalk,
	
	// Animation NormalMaps
	idle_normalmap: spritepack_get_uvs_transformed(sWilliamDS_Heavy_Idle, sWilliamDS_Heavy_Idle_NormalMap),
	walk_normalmap: spritepack_get_uvs_transformed(sWilliamDS_Heavy_Run, sWilliamDS_Heavy_Run_NormalMap),
	jump_normalmap: spritepack_get_uvs_transformed(sWilliamDS_Heavy_Jump, sWilliamDS_Heavy_Jump_NormalMap),
	aim_normalmap: spritepack_get_uvs_transformed(sWilliamDS_Heavy_Aim, sWilliamDS_Heavy_Aim_NormalMap),
	aim_walk_normalmap: spritepack_get_uvs_transformed(sWilliamDS_Heavy_AimWalk, sWilliamDS_Heavy_AimWalk_NormalMap),
	
	// Bodypart Sprites
	ragdoll_head_sprite: sWilliamDS_Heavy_Head,
	ragdoll_arm_left_sprite: sWilliamDS_Heavy_Arms,
	ragdoll_arm_right_sprite: sWilliamDS_Heavy_Arms,
	ragdoll_chest_top_sprite: sWilliamDS_Heavy_ChestTop,
	ragdoll_chest_bot_sprite: sWilliamDS_Heavy_ChestBot,
	ragdoll_leg_left_sprite: sWilliamDS_Heavy_LeftLeg,
	ragdoll_leg_right_sprite: sWilliamDS_Heavy_RightLeg,
	
	// Bodypart NormalMaps
	ragdoll_head_normalmap: spritepack_get_uvs_transformed(sWilliamDS_Heavy_Head, sWilliamDS_Heavy_Head_NormalMap),
	ragdoll_arm_left_normalmap: spritepack_get_uvs_transformed(sWilliamDS_Heavy_Arms, sWilliamDS_Heavy_Arms_NormalMap),
	ragdoll_arm_right_normalmap: spritepack_get_uvs_transformed(sWilliamDS_Heavy_Arms, sWilliamDS_Heavy_Arms_NormalMap),
	ragdoll_chest_top_normalmap: spritepack_get_uvs_transformed(sWilliamDS_Heavy_ChestTop, sWilliamDS_Heavy_ChestTop_NormalMap),
	ragdoll_chest_bot_normalmap: spritepack_get_uvs_transformed(sWilliamDS_Heavy_ChestBot, sWilliamDS_Heavy_ChestBot_NormalMap),
	ragdoll_leg_left_normalmap: spritepack_get_uvs_transformed(sWilliamDS_Heavy_LeftLeg, sWilliamDS_Heavy_LeftLeg_NormalMap),
	ragdoll_leg_right_normalmap: spritepack_get_uvs_transformed(sWilliamDS_Heavy_RightLeg, sWilliamDS_Heavy_RightLeg_NormalMap),
	
	// Limb & Equipment Positions
	limb_anchor_left_arm_x: -6,
	limb_anchor_left_arm_y: -37,
	
	limb_anchor_right_arm_x: 5,
	limb_anchor_right_arm_y: -37,
	
	equipment_inventory_x: -6,
	equipment_inventory_y: -27,
	
	equipment_firearm_hip_x: -1,
	equipment_firearm_hip_y: -30,
	
	equipment_firearm_aim_x: 5,
	equipment_firearm_aim_y: -38,
}

// Northern Brigade Soldier
global.unit_packs[UnitPack.NorthernBrigadeSoldier] = 
{
	// Animation Sprites
	idle_sprite: sWilliam_NorthernBrigade_Soldat_Idle,
	walk_sprite: sWilliam_NorthernBrigade_Soldat_Run,
	jump_sprite: sWilliam_NorthernBrigade_Soldat_Jump,
	aim_sprite: sWilliam_NorthernBrigade_Soldat_Aim,
	aim_walk_sprite: sWilliam_NorthernBrigade_Soldat_AimWalk,
	
	// Animation NormalMaps
	idle_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_Soldat_Idle, sWilliam_NorthernBrigade_Soldat_Idle_NormalMap),
	walk_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_Soldat_Run, sWilliam_NorthernBrigade_Soldat_Run_NormalMap),
	jump_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_Soldat_Jump, sWilliam_NorthernBrigade_Soldat_Jump_NormalMap),
	aim_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_Soldat_Aim, sWilliam_NorthernBrigade_Soldat_Aim_NormalMap),
	aim_walk_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_Soldat_AimWalk, sWilliam_NorthernBrigade_Soldat_AimWalk_NormalMap),
	
	// Bodypart Sprites
	ragdoll_head_sprite: sWilliam_NorthernBrigade_Soldat_Head,
	ragdoll_arm_left_sprite: sWilliam_NorthernBrigade_Arms,
	ragdoll_arm_right_sprite: sWilliam_NorthernBrigade_Arms,
	ragdoll_chest_top_sprite: sWilliam_NorthernBrigade_Soldat_ChestTop,
	ragdoll_chest_bot_sprite: sWilliam_NorthernBrigade_Soldat_ChestBot,
	ragdoll_leg_left_sprite: sWilliam_NorthernBrigade_LeftLeg,
	ragdoll_leg_right_sprite: sWilliam_NorthernBrigade_RightLeg,
	
	// Bodypart NormalMaps
	ragdoll_head_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_Soldat_Head, sWilliam_NorthernBrigade_Soldat_Head_NormalMap),
	ragdoll_arm_left_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_Arms, sWilliam_NorthernBrigade_Arms_NormalMap),
	ragdoll_arm_right_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_Arms, sWilliam_NorthernBrigade_Arms_NormalMap),
	ragdoll_chest_top_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_Soldat_ChestTop, sWilliam_NorthernBrigade_Soldat_ChestTop_NormalMap),
	ragdoll_chest_bot_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_Soldat_ChestBot, sWilliam_NorthernBrigade_Soldat_ChestBot_NormalMap),
	ragdoll_leg_left_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_LeftLeg, sWilliam_NorthernBrigade_LeftLeg_NormalMap),
	ragdoll_leg_right_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_RightLeg, sWilliam_NorthernBrigade_RightLeg_NormalMap),
	
	// Limb & Equipment Positions
	limb_anchor_left_arm_x: -6,
	limb_anchor_left_arm_y: -32,
	
	limb_anchor_right_arm_x: 4,
	limb_anchor_right_arm_y: -32,
	
	equipment_inventory_x: -8,
	equipment_inventory_y: -21,
	
	equipment_firearm_hip_x: -4,
	equipment_firearm_hip_y: -28,
	
	equipment_firearm_aim_x: 5,
	equipment_firearm_aim_y: -40,
}

// Northern Brigade Officer
global.unit_packs[UnitPack.NorthernBrigadeOfficer] = 
{
	// Animation Sprites
	idle_sprite: sWilliam_NorthernBrigade_Idle,
	walk_sprite: sWilliam_NorthernBrigade_Run,
	jump_sprite: sWilliam_NorthernBrigade_Jump,
	aim_sprite: sWilliam_NorthernBrigade_Aim,
	aim_walk_sprite: sWilliam_NorthernBrigade_AimWalk,
	
	// Animation NormalMaps
	idle_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_Idle, sWilliam_NorthernBrigade_Idle_NormalMap),
	walk_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_Run, sWilliam_NorthernBrigade_Run_NormalMap),
	jump_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_Jump, sWilliam_NorthernBrigade_Jump_NormalMap),
	aim_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_Aim, sWilliam_NorthernBrigade_Aim_NormalMap),
	aim_walk_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_AimWalk, sWilliam_NorthernBrigade_AimWalk_NormalMap),
	
	// Bodypart Sprites
	ragdoll_head_sprite: sWilliam_NorthernBrigade_Head,
	ragdoll_arm_left_sprite: sWilliam_NorthernBrigade_Arms,
	ragdoll_arm_right_sprite: sWilliam_NorthernBrigade_Arms,
	ragdoll_chest_top_sprite: sWilliam_NorthernBrigade_ChestTop,
	ragdoll_chest_bot_sprite: sWilliam_NorthernBrigade_ChestBot,
	ragdoll_leg_left_sprite: sWilliam_NorthernBrigade_LeftLeg,
	ragdoll_leg_right_sprite: sWilliam_NorthernBrigade_RightLeg,
	
	// Bodypart NormalMaps
	ragdoll_head_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_Head, sWilliam_NorthernBrigade_Head_NormalMap),
	ragdoll_arm_left_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_Arms, sWilliam_NorthernBrigade_Arms_NormalMap),
	ragdoll_arm_right_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_Arms, sWilliam_NorthernBrigade_Arms_NormalMap),
	ragdoll_chest_top_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_ChestTop, sWilliam_NorthernBrigade_ChestTop_NormalMap),
	ragdoll_chest_bot_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_ChestBot, sWilliam_NorthernBrigade_ChestBot_NormalMap),
	ragdoll_leg_left_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_LeftLeg, sWilliam_NorthernBrigade_LeftLeg_NormalMap),
	ragdoll_leg_right_normalmap: spritepack_get_uvs_transformed(sWilliam_NorthernBrigade_RightLeg, sWilliam_NorthernBrigade_RightLeg_NormalMap),
	
	// Limb & Equipment Positions
	limb_anchor_left_arm_x: -4,
	limb_anchor_left_arm_y: -32,
	
	limb_anchor_right_arm_x: 4,
	limb_anchor_right_arm_y: -32,
	
	equipment_inventory_x: -8,
	equipment_inventory_y: -21,
	
	equipment_firearm_hip_x: -4,
	equipment_firearm_hip_y: -28,
	
	equipment_firearm_aim_x: 5,
	equipment_firearm_aim_y: -40,
	
	// Limb Animation Settings
	limb_idle_animation_extension_percent: 0.4,
	limb_idle_animation_ambient_move_width: 0,
	limb_left_arm_idle_animation_angle: 4,
	limb_right_arm_idle_animation_angle: -20,
		
	limb_left_arm_walk_animation_extension_percent: 0.45,
	limb_left_arm_walk_animation_ambient_move_width: 2,
	limb_left_arm_walk_animation_ambient_move_height: 1,
	limb_left_arm_walk_animation_angle: 20,
		
	limb_right_arm_walk_animation_extension_percent: 0.55,
	limb_right_arm_walk_animation_ambient_move_width: 2,
	limb_right_arm_walk_animation_ambient_move_height: 1,
	limb_right_arm_walk_animation_angle: 45,
		
	limb_jump_animation_extension_percent: 0.65,
	limb_left_arm_jump_animation_angle: -14,
	limb_right_arm_jump_animation_angle: 24,
}


















