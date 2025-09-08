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
    Item,
    Melee,
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

// Unit Combat Enums
enum UnitCombatStrategy
{
	FireUntilNeutralized,
	NullStrategy
}

enum UnitCombatPriorityRank
{
	PriorityCombat,
	CloseCombat,
	ArchitectCombat,
	GroundVehicleCombat,
	EliteCombat,
	InfantryCombat,
	SupportHighPriorityCombat,
	SupportLowPriorityCombat,
	NullPriorityCombat
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
	// Animation Diffuse Maps
	idle_sprite: sWilliam_CapitalLoyalist_Idle,
	walk_sprite: sWilliam_CapitalLoyalist_Run,
	jump_sprite: sWilliam_CapitalLoyalist_Jump,
	aim_sprite: sWilliam_CapitalLoyalist_Aim,
	aim_walk_sprite: sWilliam_CapitalLoyalist_AimWalk,
	
	// Animation Normal Maps
	idle_normalmap: sWilliam_CapitalLoyalist_Idle_NormalMap,
	walk_normalmap: sWilliam_CapitalLoyalist_Run_NormalMap,
	jump_normalmap: sWilliam_CapitalLoyalist_Jump_NormalMap,
	aim_normalmap: sWilliam_CapitalLoyalist_Aim_NormalMap,
	aim_walk_normalmap: sWilliam_CapitalLoyalist_AimWalk_NormalMap,
	
	// Animation Metallic-Roughness Maps
	idle_metallicroughnessmap: noone,
	walk_metallicroughnessmap: noone,
	jump_metallicroughnessmap: noone,
	aim_metallicroughnessmap: noone,
	aim_walk_metallicroughnessmap: noone,
	
	// Animation Emissive Maps
	idle_emissivemap: noone,
	walk_emissivemap: noone,
	jump_emissivemap: noone,
	aim_emissivemap: noone,
	aim_walk_emissivemap: noone,
	
	// Bodypart Diffuse Maps
	ragdoll_head_sprite: sWilliam_CapitalLoyalist_Head,
	ragdoll_arm_left_sprite: sWilliam_CapitalLoyalist_Arms,
	ragdoll_arm_right_sprite: sWilliam_CapitalLoyalist_Arms,
	ragdoll_chest_top_sprite: sWilliam_CapitalLoyalist_ChestTop,
	ragdoll_chest_bot_sprite: sWilliam_CapitalLoyalist_ChestBot,
	ragdoll_leg_left_sprite: sWilliam_CapitalLoyalist_LeftLeg,
	ragdoll_leg_right_sprite: sWilliam_CapitalLoyalist_RightLeg,
	
	// Bodypart Normal Maps
	ragdoll_head_normalmap: sWilliam_CapitalLoyalist_Head_NormalMap,
	ragdoll_arm_left_normalmap: sWilliam_CapitalLoyalist_Arms_NormalMap,
	ragdoll_arm_right_normalmap: sWilliam_CapitalLoyalist_Arms_NormalMap,
	ragdoll_chest_top_normalmap: sWilliam_CapitalLoyalist_ChestTop_NormalMap,
	ragdoll_chest_bot_normalmap: sWilliam_CapitalLoyalist_ChestBot_NormalMap,
	ragdoll_leg_left_normalmap: sWilliam_CapitalLoyalist_LeftLeg_NormalMap,
	ragdoll_leg_right_normalmap: sWilliam_CapitalLoyalist_RightLeg_NormalMap,
	
	// Bodypart Metallic-Roughness Maps
	ragdoll_head_metallicroughnessmap: noone,
	ragdoll_arm_left_metallicroughnessmap: noone,
	ragdoll_arm_right_metallicroughnessmap: noone,
	ragdoll_chest_top_metallicroughnessmap: noone,
	ragdoll_chest_bot_metallicroughnessmap: noone,
	ragdoll_leg_left_metallicroughnessmap: noone,
	ragdoll_leg_right_metallicroughnessmap: noone,
	
	// Bodypart Emissive Maps
	ragdoll_head_emissivemap: noone,
	ragdoll_arm_left_emissivemap: noone,
	ragdoll_arm_right_emissivemap: noone,
	ragdoll_chest_top_emissivemap: noone,
	ragdoll_chest_bot_emissivemap: noone,
	ragdoll_leg_left_emissivemap: noone,
	ragdoll_leg_right_emissivemap: noone,
	
	// Ragdoll Settings
	ragdoll_head_offset: -4,
	ragdoll_arms_offset: 4,
	ragdoll_legs_offset: 4,
	
	// PBR Settings
	metallic: false,
	roughness: 0.1,
	emissive: 0.0,
	
	// Limb & Equipment Positions
	limb_anchor_left_arm_x: -7,
	limb_anchor_left_arm_y: -35,
	
	limb_anchor_right_arm_x: 4,
	limb_anchor_right_arm_y: -35,
	
	equipment_inventory_x: -3,
	equipment_inventory_y: -28,
	
	equipment_item_x: 0,
	equipment_item_y: -32,
	
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
	
	// Inventory Slots
	inventory_slot_init: function(unit)
	{
		unit_inventory_add_slot(unit, "Backpack", UnitInventorySlotTier.Hefty, 0, -28, 35, UnitInventorySlotRenderOrder.Back);
		unit_inventory_add_slot(unit, "Belt Box", UnitInventorySlotTier.Moderate, -4, -24, 180, UnitInventorySlotRenderOrder.Front);
		unit_inventory_add_slot(unit, "Pocket", UnitInventorySlotTier.Light, 4, -26, 0, UnitInventorySlotRenderOrder.None);
		unit_inventory_add_slot(unit, "Pocket", UnitInventorySlotTier.Light, 4, -26, 0, UnitInventorySlotRenderOrder.None);
	}
};

// Moralist William
global.unit_packs[UnitPack.MoralistWilliam] = 
{
	// Animation Diffuse Maps
	idle_sprite: sWilliam_CapitalLoyalist_Idle,
	walk_sprite: sWilliam_CapitalLoyalist_Run,
	jump_sprite: sWilliam_CapitalLoyalist_Jump,
	aim_sprite: sWilliam_CapitalLoyalist_Aim,
	aim_walk_sprite: sWilliam_CapitalLoyalist_AimWalk,
	
	// Animation Normal Maps
	idle_normalmap: sWilliam_CapitalLoyalist_Idle_NormalMap,
	walk_normalmap: sWilliam_CapitalLoyalist_Run_NormalMap,
	jump_normalmap: sWilliam_CapitalLoyalist_Jump_NormalMap,
	aim_normalmap: sWilliam_CapitalLoyalist_Aim_NormalMap,
	aim_walk_normalmap: sWilliam_CapitalLoyalist_AimWalk_NormalMap,
	
	// Animation Metallic-Roughness Maps
	idle_metallicroughnessmap: noone,
	walk_metallicroughnessmap: noone,
	jump_metallicroughnessmap: noone,
	aim_metallicroughnessmap: noone,
	aim_walk_metallicroughnessmap: noone,
	
	// Animation Emissive Maps
	idle_emissivemap: noone,
	walk_emissivemap: noone,
	jump_emissivemap: noone,
	aim_emissivemap: noone,
	aim_walk_emissivemap: noone,
	
	// Bodypart Diffuse Maps
	ragdoll_head_sprite: sWilliam_CapitalLoyalist_Head,
	ragdoll_arm_left_sprite: sWilliam_CapitalLoyalist_Arms,
	ragdoll_arm_right_sprite: sWilliam_CapitalLoyalist_Arms,
	ragdoll_chest_top_sprite: sWilliam_CapitalLoyalist_ChestTop,
	ragdoll_chest_bot_sprite: sWilliam_CapitalLoyalist_ChestBot,
	ragdoll_leg_left_sprite: sWilliam_CapitalLoyalist_LeftLeg,
	ragdoll_leg_right_sprite: sWilliam_CapitalLoyalist_RightLeg,
	
	// Bodypart Normal Maps
	ragdoll_head_normalmap: sWilliam_CapitalLoyalist_Head_NormalMap,
	ragdoll_arm_left_normalmap: sWilliam_CapitalLoyalist_Arms_NormalMap,
	ragdoll_arm_right_normalmap: sWilliam_CapitalLoyalist_Arms_NormalMap,
	ragdoll_chest_top_normalmap: sWilliam_CapitalLoyalist_ChestTop_NormalMap,
	ragdoll_chest_bot_normalmap: sWilliam_CapitalLoyalist_ChestBot_NormalMap,
	ragdoll_leg_left_normalmap: sWilliam_CapitalLoyalist_LeftLeg_NormalMap,
	ragdoll_leg_right_normalmap: sWilliam_CapitalLoyalist_RightLeg_NormalMap,
	
	// Bodypart Metallic-Roughness Maps
	ragdoll_head_metallicroughnessmap: noone,
	ragdoll_arm_left_metallicroughnessmap: noone,
	ragdoll_arm_right_metallicroughnessmap: noone,
	ragdoll_chest_top_metallicroughnessmap: noone,
	ragdoll_chest_bot_metallicroughnessmap: noone,
	ragdoll_leg_left_metallicroughnessmap: noone,
	ragdoll_leg_right_metallicroughnessmap: noone,
	
	// Bodypart Emissive Maps
	ragdoll_head_emissivemap: noone,
	ragdoll_arm_left_emissivemap: noone,
	ragdoll_arm_right_emissivemap: noone,
	ragdoll_chest_top_emissivemap: noone,
	ragdoll_chest_bot_emissivemap: noone,
	ragdoll_leg_left_emissivemap: noone,
	ragdoll_leg_right_emissivemap: noone,
	
	// Ragdoll Settings
	ragdoll_head_offset: -4,
	ragdoll_arms_offset: 4,
	ragdoll_legs_offset: 4,
	
	// PBR Settings
	metallic: false,
	roughness: 0.1,
	emissive: 0.0,
	
	// Limb & Equipment Positions
	limb_anchor_left_arm_x: -7,
	limb_anchor_left_arm_y: -35,
	
	limb_anchor_right_arm_x: 4,
	limb_anchor_right_arm_y: -35,
	
	equipment_inventory_x: -3,
	equipment_inventory_y: -28,
	
	equipment_item_x: 4,
	equipment_item_y: -16,
	
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
	
	// Inventory Slots
	inventory_slot_init: function(unit)
	{
		unit_inventory_add_slot(unit, "Backpack", UnitInventorySlotTier.Hefty, 0, -28, 35, UnitInventorySlotRenderOrder.Back);
		unit_inventory_add_slot(unit, "Belt Box", UnitInventorySlotTier.Moderate, -8, -24, 0, UnitInventorySlotRenderOrder.Front);
		unit_inventory_add_slot(unit, "Pocket", UnitInventorySlotTier.Light, 4, -26, 0, UnitInventorySlotRenderOrder.None);
		unit_inventory_add_slot(unit, "Pocket", UnitInventorySlotTier.Light, 4, -26, 0, UnitInventorySlotRenderOrder.None);
	}
};

// Wolf
global.unit_packs[UnitPack.Wolf] = 
{
	// Animation Diffuse Maps
	idle_sprite: sWolf_Idle,
	walk_sprite: sWolf_Run,
	jump_sprite: sWolf_Jump,
	aim_sprite: sWolf_Aim,
	aim_walk_sprite: sWolf_AimWalk,
	
	// Animation Normal Maps
	idle_normalmap: sWolf_Idle_NormalMap,
	walk_normalmap: sWolf_Run_NormalMap,
	jump_normalmap: sWolf_Jump_NormalMap,
	aim_normalmap: sWolf_Aim_NormalMap,
	aim_walk_normalmap: sWolf_AimWalk_NormalMap,
	
	// Animation Metallic-Roughness Maps
	idle_metallicroughnessmap: noone,
	walk_metallicroughnessmap: noone,
	jump_metallicroughnessmap: noone,
	aim_metallicroughnessmap: noone,
	aim_walk_metallicroughnessmap: noone,
	
	// Animation Emissive Maps
	idle_emissivemap: noone,
	walk_emissivemap: noone,
	jump_emissivemap: noone,
	aim_emissivemap: noone,
	aim_walk_emissivemap: noone,
	
	// Bodypart Diffuse Maps
	ragdoll_head_sprite: sWilliam_CapitalLoyalist_Head,
	ragdoll_arm_left_sprite: sWolf_Arms,
	ragdoll_arm_right_sprite: sWolf_Arms,
	ragdoll_chest_top_sprite: sWilliam_CapitalLoyalist_ChestTop,
	ragdoll_chest_bot_sprite: sWilliam_CapitalLoyalist_ChestBot,
	ragdoll_leg_left_sprite: sWilliam_CapitalLoyalist_LeftLeg,
	ragdoll_leg_right_sprite: sWilliam_CapitalLoyalist_RightLeg,
	
	// Bodypart Normal Maps
	ragdoll_head_normalmap: sWilliam_CapitalLoyalist_Head_NormalMap,
	ragdoll_arm_left_normalmap: sWolf_Arms_NormalMap,
	ragdoll_arm_right_normalmap: sWolf_Arms_NormalMap,
	ragdoll_chest_top_normalmap: sWilliam_CapitalLoyalist_ChestTop_NormalMap,
	ragdoll_chest_bot_normalmap: sWilliam_CapitalLoyalist_ChestBot_NormalMap,
	ragdoll_leg_left_normalmap: sWilliam_CapitalLoyalist_LeftLeg_NormalMap,
	ragdoll_leg_right_normalmap: sWilliam_CapitalLoyalist_RightLeg_NormalMap,
	
	// Bodypart Metallic-Roughness Maps
	ragdoll_head_metallicroughnessmap: noone,
	ragdoll_arm_left_metallicroughnessmap: noone,
	ragdoll_arm_right_metallicroughnessmap: noone,
	ragdoll_chest_top_metallicroughnessmap: noone,
	ragdoll_chest_bot_metallicroughnessmap: noone,
	ragdoll_leg_left_metallicroughnessmap: noone,
	ragdoll_leg_right_metallicroughnessmap: noone,
	
	// Bodypart Emissive Maps
	ragdoll_head_emissivemap: noone,
	ragdoll_arm_left_emissivemap: noone,
	ragdoll_arm_right_emissivemap: noone,
	ragdoll_chest_top_emissivemap: noone,
	ragdoll_chest_bot_emissivemap: noone,
	ragdoll_leg_left_emissivemap: noone,
	ragdoll_leg_right_emissivemap: noone,
	
	// Ragdoll Settings
	ragdoll_head_offset: -4,
	ragdoll_arms_offset: 4,
	ragdoll_legs_offset: 4,
	
	// PBR Settings
	metallic: false,
	roughness: 0.1,
	emissive: 0.0,
	
	// Limb & Equipment Positions
	limb_anchor_left_arm_x: -7,
	limb_anchor_left_arm_y: -34,
	
	limb_anchor_right_arm_x: 3,
	limb_anchor_right_arm_y: -34,
	
	equipment_inventory_x: -2,
	equipment_inventory_y: -22,
	
	equipment_item_x: 0,
	equipment_item_y: -35,
	
	equipment_firearm_hip_x: -6,
	equipment_firearm_hip_y: -22,
	
	equipment_firearm_aim_x: 3,
	equipment_firearm_aim_y: -29,
	
	// Inventory Slots
	inventory_slot_init: function(unit)
	{
		unit_inventory_add_slot(unit, "Backpack", UnitInventorySlotTier.Hefty, 0, -28, 35, UnitInventorySlotRenderOrder.Back);
		unit_inventory_add_slot(unit, "Belt Box", UnitInventorySlotTier.Moderate, -8, -24, 0, UnitInventorySlotRenderOrder.Front);
		unit_inventory_add_slot(unit, "Pocket", UnitInventorySlotTier.Light, 4, -26, 0, UnitInventorySlotRenderOrder.None);
		unit_inventory_add_slot(unit, "Pocket", UnitInventorySlotTier.Light, 4, -26, 0, UnitInventorySlotRenderOrder.None);
	}
};

// Director
global.unit_packs[UnitPack.Director] = 
{
	// Animation Diffuse Maps
	idle_sprite: sWilliam_Director_Idle,
	walk_sprite: sWilliam_Director_Run,
	jump_sprite: sWilliam_Director_Jump,
	aim_sprite: sWilliam_Director_Aim,
	aim_walk_sprite: sWilliam_Director_AimWalk,
	
	// Animation Normal Maps
	idle_normalmap: sWilliam_Director_Idle_NormalMap,
	walk_normalmap: sWilliam_Director_Run_NormalMap,
	jump_normalmap: sWilliam_Director_Jump_NormalMap,
	aim_normalmap: sWilliam_Director_Aim_NormalMap,
	aim_walk_normalmap: sWilliam_Director_AimWalk_NormalMap,
	
	// Animation Metallic-Roughness Maps
	idle_metallicroughnessmap: noone,
	walk_metallicroughnessmap: noone,
	jump_metallicroughnessmap: noone,
	aim_metallicroughnessmap: noone,
	aim_walk_metallicroughnessmap: noone,
	
	// Animation Emissive Maps
	idle_emissivemap: noone,
	walk_emissivemap: noone,
	jump_emissivemap: noone,
	aim_emissivemap: noone,
	aim_walk_emissivemap: noone,
	
	// Bodypart Diffuse Maps
	ragdoll_head_sprite: sWilliam_Knives_Head,
	ragdoll_arm_left_sprite: sWilliam_Director_Arms,
	ragdoll_arm_right_sprite: sWilliam_Director_Arms,
	ragdoll_chest_top_sprite: sWilliam_Knives_ChestTop,
	ragdoll_chest_bot_sprite: sWilliam_Knives_ChestBot,
	ragdoll_leg_left_sprite: sWilliam_Knives_LeftLeg,
	ragdoll_leg_right_sprite: sWilliam_Knives_RightLeg,
	
	// Bodypart Normal Maps
	ragdoll_head_normalmap: sWilliam_Knives_Head_NormalMap,
	ragdoll_arm_left_normalmap: sWilliam_Director_Arms_NormalMap,
	ragdoll_arm_right_normalmap: sWilliam_Director_Arms_NormalMap,
	ragdoll_chest_top_normalmap: sWilliam_Knives_ChestTop_NormalMap,
	ragdoll_chest_bot_normalmap: sWilliam_Knives_ChestBot_NormalMap,
	ragdoll_leg_left_normalmap: sWilliam_Knives_LeftLeg_NormalMap,
	ragdoll_leg_right_normalmap: sWilliam_Knives_RightLeg_NormalMap,
	
	// Bodypart Metallic-Roughness Maps
	ragdoll_head_metallicroughnessmap: noone,
	ragdoll_arm_left_metallicroughnessmap: noone,
	ragdoll_arm_right_metallicroughnessmap: noone,
	ragdoll_chest_top_metallicroughnessmap: noone,
	ragdoll_chest_bot_metallicroughnessmap: noone,
	ragdoll_leg_left_metallicroughnessmap: noone,
	ragdoll_leg_right_metallicroughnessmap: noone,
	
	// Bodypart Emissive Maps
	ragdoll_head_emissivemap: noone,
	ragdoll_arm_left_emissivemap: noone,
	ragdoll_arm_right_emissivemap: noone,
	ragdoll_chest_top_emissivemap: noone,
	ragdoll_chest_bot_emissivemap: noone,
	ragdoll_leg_left_emissivemap: noone,
	ragdoll_leg_right_emissivemap: noone,
	
	// Ragdoll Settings
	ragdoll_head_offset: -4,
	ragdoll_arms_offset: 4,
	ragdoll_legs_offset: 4,
	
	// PBR Settings
	metallic: false,
	roughness: 0.1,
	emissive: 0.0,
	
	// Limb & Equipment Positions
	limb_anchor_left_arm_x: -5,
	limb_anchor_left_arm_y: -37,
	
	limb_anchor_right_arm_x: 4,
	limb_anchor_right_arm_y: -35,
	
	equipment_inventory_x: -3,
	equipment_inventory_y: -28,
	
	equipment_item_x: 0,
	equipment_item_y: -35,
	
	equipment_firearm_hip_x: -2,
	equipment_firearm_hip_y: -30,
	
	equipment_firearm_aim_x: 5,
	equipment_firearm_aim_y: -41,
	
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
	
	// Inventory Slots
	inventory_slot_init: function(unit)
	{
		unit_inventory_add_slot(unit, "Backpack", UnitInventorySlotTier.Hefty, 0, -28, 35, UnitInventorySlotRenderOrder.Back);
		unit_inventory_add_slot(unit, "Belt Box", UnitInventorySlotTier.Moderate, -8, -24, 0, UnitInventorySlotRenderOrder.Front);
		unit_inventory_add_slot(unit, "Pocket", UnitInventorySlotTier.Light, 4, -26, 0, UnitInventorySlotRenderOrder.None);
		unit_inventory_add_slot(unit, "Pocket", UnitInventorySlotTier.Light, 4, -26, 0, UnitInventorySlotRenderOrder.None);
	}
};

// Knives
global.unit_packs[UnitPack.Knives] = 
{
	// Animation Diffuse Maps
	idle_sprite: sWilliam_Knives_Idle,
	walk_sprite: sWilliam_Knives_Run,
	jump_sprite: sWilliam_Knives_Jump,
	aim_sprite: sWilliam_Knives_Aim,
	aim_walk_sprite: sWilliam_Knives_AimWalk,
	
	// Animation Normal Maps
	idle_normalmap: sWilliam_Knives_Idle_NormalMap,
	walk_normalmap: sWilliam_Knives_Run_NormalMap,
	jump_normalmap: sWilliam_Knives_Jump_NormalMap,
	aim_normalmap: sWilliam_Knives_Aim_NormalMap,
	aim_walk_normalmap: sWilliam_Knives_AimWalk_NormalMap,
	
	// Animation Metallic-Roughness Maps
	idle_metallicroughnessmap: noone,
	walk_metallicroughnessmap: noone,
	jump_metallicroughnessmap: noone,
	aim_metallicroughnessmap: noone,
	aim_walk_metallicroughnessmap: noone,
	
	// Animation Emissive Maps
	idle_emissivemap: noone,
	walk_emissivemap: noone,
	jump_emissivemap: noone,
	aim_emissivemap: noone,
	aim_walk_emissivemap: noone,
	
	// Bodypart Diffuse Maps
	ragdoll_head_sprite: sWilliam_Knives_Head,
	ragdoll_arm_left_sprite: sWilliam_Knives_Arms,
	ragdoll_arm_right_sprite: sWilliam_Knives_Arms,
	ragdoll_chest_top_sprite: sWilliam_Knives_ChestTop,
	ragdoll_chest_bot_sprite: sWilliam_Knives_ChestBot,
	ragdoll_leg_left_sprite: sWilliam_Knives_LeftLeg,
	ragdoll_leg_right_sprite: sWilliam_Knives_RightLeg,
	
	// Bodypart Normal Maps
	ragdoll_head_normalmap: sWilliam_Knives_Head_NormalMap,
	ragdoll_arm_left_normalmap: sWilliam_Knives_Arms_NormalMap,
	ragdoll_arm_right_normalmap: sWilliam_Knives_Arms_NormalMap,
	ragdoll_chest_top_normalmap: sWilliam_Knives_ChestTop_NormalMap,
	ragdoll_chest_bot_normalmap: sWilliam_Knives_ChestBot_NormalMap,
	ragdoll_leg_left_normalmap: sWilliam_Knives_LeftLeg_NormalMap,
	ragdoll_leg_right_normalmap: sWilliam_Knives_RightLeg_NormalMap,
	
	// Bodypart Metallic-Roughness Maps
	ragdoll_head_metallicroughnessmap: noone,
	ragdoll_arm_left_metallicroughnessmap: noone,
	ragdoll_arm_right_metallicroughnessmap: noone,
	ragdoll_chest_top_metallicroughnessmap: noone,
	ragdoll_chest_bot_metallicroughnessmap: noone,
	ragdoll_leg_left_metallicroughnessmap: noone,
	ragdoll_leg_right_metallicroughnessmap: noone,
	
	// Bodypart Emissive Maps
	ragdoll_head_emissivemap: noone,
	ragdoll_arm_left_emissivemap: noone,
	ragdoll_arm_right_emissivemap: noone,
	ragdoll_chest_top_emissivemap: noone,
	ragdoll_chest_bot_emissivemap: noone,
	ragdoll_leg_left_emissivemap: noone,
	ragdoll_leg_right_emissivemap: noone,
	
	// Ragdoll Settings
	ragdoll_head_offset: -4,
	ragdoll_arms_offset: 4,
	ragdoll_legs_offset: 4,
	
	// PBR Settings
	metallic: false,
	roughness: 0.1,
	emissive: 0.0,
	
	// Limb & Equipment Positions
	limb_anchor_left_arm_x: -5,
	limb_anchor_left_arm_y: -34,
	
	limb_anchor_right_arm_x: 5,
	limb_anchor_right_arm_y: -34,
	
	equipment_inventory_x: -5,
	equipment_inventory_y: -21,
	
	equipment_item_x: 0,
	equipment_item_y: -35,
	
	equipment_firearm_hip_x: -4,
	equipment_firearm_hip_y: -28,
	
	equipment_firearm_aim_x: 5,
	equipment_firearm_aim_y: -38,
	
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
	
	// Inventory Slots
	inventory_slot_init: function(unit)
	{
		unit_inventory_add_slot(unit, "Backpack", UnitInventorySlotTier.Hefty, 0, -28, 35, UnitInventorySlotRenderOrder.Back);
		unit_inventory_add_slot(unit, "Belt Box", UnitInventorySlotTier.Moderate, -8, -24, 0, UnitInventorySlotRenderOrder.Front);
		unit_inventory_add_slot(unit, "Pocket", UnitInventorySlotTier.Light, 4, -26, 0, UnitInventorySlotRenderOrder.None);
		unit_inventory_add_slot(unit, "Pocket", UnitInventorySlotTier.Light, 4, -26, 0, UnitInventorySlotRenderOrder.None);
	}
};

// Martyr
global.unit_packs[UnitPack.Martyr] = 
{
	// Animation Diffuse Maps
	idle_sprite: sWilliamDS_Heavy_Idle,
	walk_sprite: sWilliamDS_Heavy_Run,
	jump_sprite: sWilliamDS_Heavy_Jump,
	aim_sprite: sWilliamDS_Heavy_Aim,
	aim_walk_sprite: sWilliamDS_Heavy_AimWalk,
	
	// Animation Normal Maps
	idle_normalmap: sWilliamDS_Heavy_Idle_NormalMap,
	walk_normalmap: sWilliamDS_Heavy_Run_NormalMap,
	jump_normalmap: sWilliamDS_Heavy_Jump_NormalMap,
	aim_normalmap: sWilliamDS_Heavy_Aim_NormalMap,
	aim_walk_normalmap: sWilliamDS_Heavy_AimWalk_NormalMap,
	
	// Animation Metallic-Roughness Maps
	idle_metallicroughnessmap: noone,
	walk_metallicroughnessmap: noone,
	jump_metallicroughnessmap: noone,
	aim_metallicroughnessmap: noone,
	aim_walk_metallicroughnessmap: noone,
	
	// Animation Emissive Maps
	idle_emissivemap: noone,
	walk_emissivemap: noone,
	jump_emissivemap: noone,
	aim_emissivemap: noone,
	aim_walk_emissivemap: noone,
	
	// Bodypart Diffuse Maps
	ragdoll_head_sprite: sWilliamDS_Heavy_Head,
	ragdoll_arm_left_sprite: sWilliamDS_Heavy_Arms,
	ragdoll_arm_right_sprite: sWilliamDS_Heavy_Arms,
	ragdoll_chest_top_sprite: sWilliamDS_Heavy_ChestTop,
	ragdoll_chest_bot_sprite: sWilliamDS_Heavy_ChestBot,
	ragdoll_leg_left_sprite: sWilliamDS_Heavy_LeftLeg,
	ragdoll_leg_right_sprite: sWilliamDS_Heavy_RightLeg,
	
	// Bodypart Normal Maps
	ragdoll_head_normalmap: sWilliamDS_Heavy_Head_NormalMap,
	ragdoll_arm_left_normalmap: sWilliamDS_Heavy_Arms_NormalMap,
	ragdoll_arm_right_normalmap: sWilliamDS_Heavy_Arms_NormalMap,
	ragdoll_chest_top_normalmap: sWilliamDS_Heavy_ChestTop_NormalMap,
	ragdoll_chest_bot_normalmap: sWilliamDS_Heavy_ChestBot_NormalMap,
	ragdoll_leg_left_normalmap: sWilliamDS_Heavy_LeftLeg_NormalMap,
	ragdoll_leg_right_normalmap: sWilliamDS_Heavy_RightLeg_NormalMap,
	
	// Bodypart Metallic-Roughness Maps
	ragdoll_head_metallicroughnessmap: noone,
	ragdoll_arm_left_metallicroughnessmap: noone,
	ragdoll_arm_right_metallicroughnessmap: noone,
	ragdoll_chest_top_metallicroughnessmap: noone,
	ragdoll_chest_bot_metallicroughnessmap: noone,
	ragdoll_leg_left_metallicroughnessmap: noone,
	ragdoll_leg_right_metallicroughnessmap: noone,
	
	// Bodypart Emissive Maps
	ragdoll_head_emissivemap: noone,
	ragdoll_arm_left_emissivemap: noone,
	ragdoll_arm_right_emissivemap: noone,
	ragdoll_chest_top_emissivemap: noone,
	ragdoll_chest_bot_emissivemap: noone,
	ragdoll_leg_left_emissivemap: noone,
	ragdoll_leg_right_emissivemap: noone,
	
	// Ragdoll Settings
	ragdoll_head_offset: -4,
	ragdoll_arms_offset: 4,
	ragdoll_legs_offset: 4,
	
	// PBR Settings
	metallic: false,
	roughness: 0.1,
	emissive: 0.0,
	
	// Limb & Equipment Positions
	limb_anchor_left_arm_x: -6,
	limb_anchor_left_arm_y: -37,
	
	limb_anchor_right_arm_x: 5,
	limb_anchor_right_arm_y: -37,
	
	equipment_inventory_x: -6,
	equipment_inventory_y: -27,
	
	equipment_item_x: 0,
	equipment_item_y: -35,
	
	equipment_firearm_hip_x: -1,
	equipment_firearm_hip_y: -30,
	
	equipment_firearm_aim_x: 5,
	equipment_firearm_aim_y: -38,
	
	// Inventory Slots
	inventory_slot_init: function(unit)
	{
		unit_inventory_add_slot(unit, "Backpack", UnitInventorySlotTier.Hefty, 0, -28, 35, UnitInventorySlotRenderOrder.Back);
		unit_inventory_add_slot(unit, "Belt Box", UnitInventorySlotTier.Moderate, -8, -24, 0, UnitInventorySlotRenderOrder.Front);
		unit_inventory_add_slot(unit, "Pocket", UnitInventorySlotTier.Light, 4, -26, 0, UnitInventorySlotRenderOrder.None);
		unit_inventory_add_slot(unit, "Pocket", UnitInventorySlotTier.Light, 4, -26, 0, UnitInventorySlotRenderOrder.None);
	}
};

// Northern Brigade Soldier
global.unit_packs[UnitPack.NorthernBrigadeSoldier] = 
{
	// Animation Diffuse Maps
	idle_sprite: sWilliam_NorthernBrigade_Soldat_Idle,
	walk_sprite: sWilliam_NorthernBrigade_Soldat_Run,
	jump_sprite: sWilliam_NorthernBrigade_Soldat_Jump,
	aim_sprite: sWilliam_NorthernBrigade_Soldat_Aim,
	aim_walk_sprite: sWilliam_NorthernBrigade_Soldat_AimWalk,
	
	// Animation Normal Maps
	idle_normalmap: sWilliam_NorthernBrigade_Soldat_Idle_NormalMap,
	walk_normalmap: sWilliam_NorthernBrigade_Soldat_Run_NormalMap,
	jump_normalmap: sWilliam_NorthernBrigade_Soldat_Jump_NormalMap,
	aim_normalmap: sWilliam_NorthernBrigade_Soldat_Aim_NormalMap,
	aim_walk_normalmap: sWilliam_NorthernBrigade_Soldat_AimWalk_NormalMap,
	
	// Animation Metallic-Roughness Maps
	idle_metallicroughnessmap: noone,
	walk_metallicroughnessmap: noone,
	jump_metallicroughnessmap: noone,
	aim_metallicroughnessmap: noone,
	aim_walk_metallicroughnessmap: noone,
	
	// Animation Emissive Maps
	idle_emissivemap: noone,
	walk_emissivemap: noone,
	jump_emissivemap: noone,
	aim_emissivemap: noone,
	aim_walk_emissivemap: noone,
	
	// Bodypart Diffuse Maps
	ragdoll_head_sprite: sWilliam_NorthernBrigade_Soldat_Head,
	ragdoll_arm_left_sprite: sWilliam_NorthernBrigade_Arms,
	ragdoll_arm_right_sprite: sWilliam_NorthernBrigade_Arms,
	ragdoll_chest_top_sprite: sWilliam_NorthernBrigade_Soldat_ChestTop,
	ragdoll_chest_bot_sprite: sWilliam_NorthernBrigade_Soldat_ChestBot,
	ragdoll_leg_left_sprite: sWilliam_NorthernBrigade_LeftLeg,
	ragdoll_leg_right_sprite: sWilliam_NorthernBrigade_RightLeg,
	
	// Bodypart Normal Maps
	ragdoll_head_normalmap: sWilliam_NorthernBrigade_Soldat_Head_NormalMap,
	ragdoll_arm_left_normalmap: sWilliam_NorthernBrigade_Arms_NormalMap,
	ragdoll_arm_right_normalmap: sWilliam_NorthernBrigade_Arms_NormalMap,
	ragdoll_chest_top_normalmap: sWilliam_NorthernBrigade_Soldat_ChestTop_NormalMap,
	ragdoll_chest_bot_normalmap: sWilliam_NorthernBrigade_Soldat_ChestBot_NormalMap,
	ragdoll_leg_left_normalmap: sWilliam_NorthernBrigade_LeftLeg_NormalMap,
	ragdoll_leg_right_normalmap: sWilliam_NorthernBrigade_RightLeg_NormalMap,
	
	// Bodypart Metallic-Roughness Maps
	ragdoll_head_metallicroughnessmap: noone,
	ragdoll_arm_left_metallicroughnessmap: noone,
	ragdoll_arm_right_metallicroughnessmap: noone,
	ragdoll_chest_top_metallicroughnessmap: noone,
	ragdoll_chest_bot_metallicroughnessmap: noone,
	ragdoll_leg_left_metallicroughnessmap: noone,
	ragdoll_leg_right_metallicroughnessmap: noone,
	
	// Bodypart Emissive Maps
	ragdoll_head_emissivemap: noone,
	ragdoll_arm_left_emissivemap: noone,
	ragdoll_arm_right_emissivemap: noone,
	ragdoll_chest_top_emissivemap: noone,
	ragdoll_chest_bot_emissivemap: noone,
	ragdoll_leg_left_emissivemap: noone,
	ragdoll_leg_right_emissivemap: noone,
	
	// Ragdoll Settings
	ragdoll_head_offset: -4,
	ragdoll_arms_offset: 4,
	ragdoll_legs_offset: 4,
	
	// PBR Settings
	metallic: false,
	roughness: 0.1,
	emissive: 0.0,
	
	// Limb & Equipment Positions
	limb_anchor_left_arm_x: -8,
	limb_anchor_left_arm_y: -33,
	
	limb_anchor_right_arm_x: 2,
	limb_anchor_right_arm_y: -33,
	
	equipment_inventory_x: -6,
	equipment_inventory_y: -24,
	
	equipment_item_x: 0,
	equipment_item_y: -35,
	
	equipment_firearm_hip_x: -2,
	equipment_firearm_hip_y: -27,
	
	equipment_firearm_aim_x: 5,
	equipment_firearm_aim_y: -40,
	
	// Limb Animation Settings
	limb_idle_animation_extension_percent: 0.95,
	limb_idle_animation_ambient_move_width: 2,
	limb_left_arm_idle_animation_angle: -5,
	limb_right_arm_idle_animation_angle: 13,
	
	limb_left_arm_walk_animation_extension_percent: 0.9,
	limb_left_arm_walk_animation_ambient_move_width: 2,
	limb_left_arm_walk_animation_ambient_move_height: 1,
	limb_left_arm_walk_animation_angle: -9,
	
	limb_right_arm_walk_animation_extension_percent: 0.9,
	limb_right_arm_walk_animation_ambient_move_width: 2,
	limb_right_arm_walk_animation_ambient_move_height: 1,
	limb_right_arm_walk_animation_angle: 12,
	
	limb_jump_animation_extension_percent: 0.95,
	limb_left_arm_jump_animation_angle: -13,
	limb_right_arm_jump_animation_angle: 18,
	
	// Inventory Slots
	inventory_slot_init: function(unit)
	{
		unit_inventory_add_slot(unit, "Backpack", UnitInventorySlotTier.Hefty, 0, -28, 35, UnitInventorySlotRenderOrder.Back);
		unit_inventory_add_slot(unit, "Belt Box", UnitInventorySlotTier.Moderate, -8, -24, 0, UnitInventorySlotRenderOrder.Front);
		unit_inventory_add_slot(unit, "Pocket", UnitInventorySlotTier.Light, 4, -26, 0, UnitInventorySlotRenderOrder.None);
		unit_inventory_add_slot(unit, "Pocket", UnitInventorySlotTier.Light, 4, -26, 0, UnitInventorySlotRenderOrder.None);
	}
};

// Northern Brigade Officer
global.unit_packs[UnitPack.NorthernBrigadeOfficer] = 
{
	// Animation Diffuse Maps
	idle_sprite: sWilliam_NorthernBrigade_Idle,
	walk_sprite: sWilliam_NorthernBrigade_Run,
	jump_sprite: sWilliam_NorthernBrigade_Jump,
	aim_sprite: sWilliam_NorthernBrigade_Aim,
	aim_walk_sprite: sWilliam_NorthernBrigade_AimWalk,
	
	// Animation Normal Maps
	idle_normalmap: sWilliam_NorthernBrigade_Idle_NormalMap,
	walk_normalmap: sWilliam_NorthernBrigade_Run_NormalMap,
	jump_normalmap: sWilliam_NorthernBrigade_Jump_NormalMap,
	aim_normalmap: sWilliam_NorthernBrigade_Aim_NormalMap,
	aim_walk_normalmap: sWilliam_NorthernBrigade_AimWalk_NormalMap,
	
	// Animation Metallic-Roughness Maps
	idle_metallicroughnessmap: noone,
	walk_metallicroughnessmap: noone,
	jump_metallicroughnessmap: noone,
	aim_metallicroughnessmap: noone,
	aim_walk_metallicroughnessmap: noone,
	
	// Animation Emissive Maps
	idle_emissivemap: noone,
	walk_emissivemap: noone,
	jump_emissivemap: noone,
	aim_emissivemap: noone,
	aim_walk_emissivemap: noone,
	
	// Bodypart Diffuse Maps
	ragdoll_head_sprite: sWilliam_NorthernBrigade_Head,
	ragdoll_arm_left_sprite: sWilliam_NorthernBrigade_Arms,
	ragdoll_arm_right_sprite: sWilliam_NorthernBrigade_Arms,
	ragdoll_chest_top_sprite: sWilliam_NorthernBrigade_ChestTop,
	ragdoll_chest_bot_sprite: sWilliam_NorthernBrigade_ChestBot,
	ragdoll_leg_left_sprite: sWilliam_NorthernBrigade_LeftLeg,
	ragdoll_leg_right_sprite: sWilliam_NorthernBrigade_RightLeg,
	
	// Bodypart Normal Maps
	ragdoll_head_normalmap: sWilliam_NorthernBrigade_Head_NormalMap,
	ragdoll_arm_left_normalmap: sWilliam_NorthernBrigade_Arms_NormalMap,
	ragdoll_arm_right_normalmap: sWilliam_NorthernBrigade_Arms_NormalMap,
	ragdoll_chest_top_normalmap: sWilliam_NorthernBrigade_ChestTop_NormalMap,
	ragdoll_chest_bot_normalmap: sWilliam_NorthernBrigade_ChestBot_NormalMap,
	ragdoll_leg_left_normalmap: sWilliam_NorthernBrigade_LeftLeg_NormalMap,
	ragdoll_leg_right_normalmap: sWilliam_NorthernBrigade_RightLeg_NormalMap,
	
	// Bodypart Metallic-Roughness Maps
	ragdoll_head_metallicroughnessmap: noone,
	ragdoll_arm_left_metallicroughnessmap: noone,
	ragdoll_arm_right_metallicroughnessmap: noone,
	ragdoll_chest_top_metallicroughnessmap: noone,
	ragdoll_chest_bot_metallicroughnessmap: noone,
	ragdoll_leg_left_metallicroughnessmap: noone,
	ragdoll_leg_right_metallicroughnessmap: noone,
	
	// Bodypart Emissive Maps
	ragdoll_head_emissivemap: noone,
	ragdoll_arm_left_emissivemap: noone,
	ragdoll_arm_right_emissivemap: noone,
	ragdoll_chest_top_emissivemap: noone,
	ragdoll_chest_bot_emissivemap: noone,
	ragdoll_leg_left_emissivemap: noone,
	ragdoll_leg_right_emissivemap: noone,
	
	// Ragdoll Settings
	ragdoll_head_offset: -4,
	ragdoll_arms_offset: 4,
	ragdoll_legs_offset: 4,
	
	// PBR Settings
	metallic: false,
	roughness: 0.1,
	emissive: 0.0,
	
	// Limb & Equipment Positions
	limb_anchor_left_arm_x: -8,
	limb_anchor_left_arm_y: -32,
	
	limb_anchor_right_arm_x: 4,
	limb_anchor_right_arm_y: -32,
	
	equipment_inventory_x: -7,
	equipment_inventory_y: -23,
	
	equipment_item_x: 0,
	equipment_item_y: -35,
	
	equipment_firearm_hip_x: -2,
	equipment_firearm_hip_y: -27,
	
	equipment_firearm_aim_x: 5,
	equipment_firearm_aim_y: -40,
	
	// Limb Animation Settings
	limb_idle_animation_extension_percent: 0.95,
	limb_idle_animation_ambient_move_width: 2,
	limb_left_arm_idle_animation_angle: -5,
	limb_right_arm_idle_animation_angle: 13,
	
	limb_left_arm_walk_animation_extension_percent: 0.9,
	limb_left_arm_walk_animation_ambient_move_width: 2,
	limb_left_arm_walk_animation_ambient_move_height: 1,
	limb_left_arm_walk_animation_angle: -9,
	
	limb_right_arm_walk_animation_extension_percent: 0.9,
	limb_right_arm_walk_animation_ambient_move_width: 2,
	limb_right_arm_walk_animation_ambient_move_height: 1,
	limb_right_arm_walk_animation_angle: 12,
	
	limb_jump_animation_extension_percent: 0.95,
	limb_left_arm_jump_animation_angle: -13,
	limb_right_arm_jump_animation_angle: 18,
	
	// Inventory Slots
	inventory_slot_init: function(unit)
	{
		unit_inventory_add_slot(unit, "Backpack", UnitInventorySlotTier.Hefty, 0, -28, 35, UnitInventorySlotRenderOrder.Back);
		unit_inventory_add_slot(unit, "Belt Box", UnitInventorySlotTier.Moderate, -8, -24, 0, UnitInventorySlotRenderOrder.Front);
		unit_inventory_add_slot(unit, "Pocket", UnitInventorySlotTier.Light, 4, -26, 0, UnitInventorySlotRenderOrder.None);
		unit_inventory_add_slot(unit, "Pocket", UnitInventorySlotTier.Light, 4, -26, 0, UnitInventorySlotRenderOrder.None);
	}
};















