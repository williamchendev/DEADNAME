// Unit Animation States
enum UnitAnimationState
{
    Idle,
    Walking,
    Jumping,
    Aiming,
    AimWalking
}

// Unit Sprite Pack Enums
enum UnitSpritePacks
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
global.unit_sprite_packs[UnitSpritePacks.Default] = 
{
    // Animation Sprites
    idle_sprite: sWilliam_CapitalLoyalist_Idle,
    walk_sprite: sWilliam_CapitalLoyalist_Run,
    jump_sprite: sWilliam_CapitalLoyalist_Jump,
    aim_sprite: sWilliam_CapitalLoyalist_Aim,
    aim_walk_sprite: sWilliam_CapitalLoyalist_AimWalk,

    // Animation NormalMaps
    idle_normalmap: sWilliam_CapitalLoyalist_Idle_NormalMap,
    walk_normalmap: sWilliam_CapitalLoyalist_Run_NormalMap,
    jump_normalmap: sWilliam_CapitalLoyalist_Jump_NormalMap,
    aim_normalmap: sWilliam_CapitalLoyalist_Aim_NormalMap,
    aim_walk_normalmap: sWilliam_CapitalLoyalist_AimWalk_NormalMap,
    
    // Bodypart Sprites
    ragdoll_head_sprite: sWilliam_CapitalLoyalist_Head,
    ragdoll_arm_left_sprite: sWilliam_CapitalLoyalist_Arms,
    ragdoll_arm_right_sprite: sWilliam_CapitalLoyalist_Arms,
    ragdoll_chest_top_sprite: sWilliam_CapitalLoyalist_ChestTop,
    ragdoll_chest_bot_sprite: sWilliam_CapitalLoyalist_ChestBot,
    ragdoll_leg_left_sprite: sWilliam_CapitalLoyalist_LeftLeg,
    ragdoll_leg_right_sprite: sWilliam_CapitalLoyalist_RightLeg,
    
    // Bodypart NormalMaps
    ragdoll_head_normalmap: sWilliam_CapitalLoyalist_Head_NormalMap,
    ragdoll_arm_left_normalmap: sWilliam_CapitalLoyalist_Arms_NormalMap,
    ragdoll_arm_right_normalmap: sWilliam_CapitalLoyalist_Arms_NormalMap,
    ragdoll_chest_top_normalmap: sWilliam_CapitalLoyalist_ChestTop_NormalMap,
    ragdoll_chest_bot_normalmap: sWilliam_CapitalLoyalist_ChestBot_NormalMap,
    ragdoll_leg_left_normalmap: sWilliam_CapitalLoyalist_LeftLeg_NormalMap,
    ragdoll_leg_right_normalmap: sWilliam_CapitalLoyalist_RightLeg_NormalMap,
}

// Moralist William
global.unit_sprite_packs[UnitSpritePacks.MoralistWilliam] = 
{
    // Animation Sprites
    idle_sprite: sWilliam_CapitalLoyalist_Idle,
    walk_sprite: sWilliam_CapitalLoyalist_Run,
    jump_sprite: sWilliam_CapitalLoyalist_Jump,
    aim_sprite: sWilliam_CapitalLoyalist_Aim,
    aim_walk_sprite: sWilliam_CapitalLoyalist_AimWalk,

    // Animation NormalMaps
    idle_normalmap: sWilliam_CapitalLoyalist_Idle_NormalMap,
    walk_normalmap: sWilliam_CapitalLoyalist_Run_NormalMap,
    jump_normalmap: sWilliam_CapitalLoyalist_Jump_NormalMap,
    aim_normalmap: sWilliam_CapitalLoyalist_Aim_NormalMap,
    aim_walk_normalmap: sWilliam_CapitalLoyalist_AimWalk_NormalMap,
    
    // Bodypart Sprites
    ragdoll_head_sprite: sWilliam_CapitalLoyalist_Head,
    ragdoll_arm_left_sprite: sWilliam_CapitalLoyalist_Arms,
    ragdoll_arm_right_sprite: sWilliam_CapitalLoyalist_Arms,
    ragdoll_chest_top_sprite: sWilliam_CapitalLoyalist_ChestTop,
    ragdoll_chest_bot_sprite: sWilliam_CapitalLoyalist_ChestBot,
    ragdoll_leg_left_sprite: sWilliam_CapitalLoyalist_LeftLeg,
    ragdoll_leg_right_sprite: sWilliam_CapitalLoyalist_RightLeg,
    
    // Bodypart NormalMaps
    ragdoll_head_normalmap: sWilliam_CapitalLoyalist_Head_NormalMap,
    ragdoll_arm_left_normalmap: sWilliam_CapitalLoyalist_Arms_NormalMap,
    ragdoll_arm_right_normalmap: sWilliam_CapitalLoyalist_Arms_NormalMap,
    ragdoll_chest_top_normalmap: sWilliam_CapitalLoyalist_ChestTop_NormalMap,
    ragdoll_chest_bot_normalmap: sWilliam_CapitalLoyalist_ChestBot_NormalMap,
    ragdoll_leg_left_normalmap: sWilliam_CapitalLoyalist_LeftLeg_NormalMap,
    ragdoll_leg_right_normalmap: sWilliam_CapitalLoyalist_RightLeg_NormalMap,
}

// Wolf
global.unit_sprite_packs[UnitSpritePacks.Wolf] = 
{
    // Animation Sprites
    idle_sprite: sWolf_Idle,
    walk_sprite: sWolf_Run,
    jump_sprite: sWolf_Jump,
    aim_sprite: sWolf_Aim,
    aim_walk_sprite: sWolf_AimWalk,

    // Animation NormalMaps
    idle_normalmap: sWolf_Idle_NormalMap,
    walk_normalmap: sWolf_Run_NormalMap,
    jump_normalmap: sWolf_Jump_NormalMap,
    aim_normalmap: sWolf_Aim_NormalMap,
    aim_walk_normalmap: sWolf_AimWalk_NormalMap,
    
    // Bodypart Sprites
    ragdoll_head_sprite: sWilliam_CapitalLoyalist_Head,
    ragdoll_arm_left_sprite: sWolf_Arms,
    ragdoll_arm_right_sprite: sWolf_Arms,
    ragdoll_chest_top_sprite: sWilliam_CapitalLoyalist_ChestTop,
    ragdoll_chest_bot_sprite: sWilliam_CapitalLoyalist_ChestBot,
    ragdoll_leg_left_sprite: sWilliam_CapitalLoyalist_LeftLeg,
    ragdoll_leg_right_sprite: sWilliam_CapitalLoyalist_RightLeg,
    
    // Bodypart NormalMaps
    ragdoll_head_normalmap: sWilliam_CapitalLoyalist_Head_NormalMap,
    ragdoll_arm_left_normalmap: sWolf_Arms_NormalMap,
    ragdoll_arm_right_normalmap: sWolf_Arms_NormalMap,
    ragdoll_chest_top_normalmap: sWilliam_CapitalLoyalist_ChestTop_NormalMap,
    ragdoll_chest_bot_normalmap: sWilliam_CapitalLoyalist_ChestBot_NormalMap,
    ragdoll_leg_left_normalmap: sWilliam_CapitalLoyalist_LeftLeg_NormalMap,
    ragdoll_leg_right_normalmap: sWilliam_CapitalLoyalist_RightLeg_NormalMap,
}

// Director
global.unit_sprite_packs[UnitSpritePacks.Director] = 
{
    // Animation Sprites
    idle_sprite: sWilliam_Director_Idle,
    walk_sprite: sWilliam_Director_Run,
    jump_sprite: sWilliam_Director_Jump,
    aim_sprite: sWilliam_Director_Aim,
    aim_walk_sprite: sWilliam_Director_AimWalk,

    // Animation NormalMaps
    idle_normalmap: sWilliam_Director_Idle_NormalMap,
    walk_normalmap: sWilliam_Director_Run_NormalMap,
    jump_normalmap: sWilliam_Director_Jump_NormalMap,
    aim_normalmap: sWilliam_Director_Aim_NormalMap,
    aim_walk_normalmap: sWilliam_Director_AimWalk_NormalMap,
    
    // Bodypart Sprites
    ragdoll_head_sprite: sWilliam_Knives_Head,
    ragdoll_arm_left_sprite: sWilliam_Director_Arms,
    ragdoll_arm_right_sprite: sWilliam_Director_Arms,
    ragdoll_chest_top_sprite: sWilliam_Knives_ChestTop,
    ragdoll_chest_bot_sprite: sWilliam_Knives_ChestBot,
    ragdoll_leg_left_sprite: sWilliam_Knives_LeftLeg,
    ragdoll_leg_right_sprite: sWilliam_Knives_RightLeg,
    
    // Bodypart NormalMaps
    ragdoll_head_normalmap: sWilliam_Knives_Head_NormalMap,
    ragdoll_arm_left_normalmap: sWilliam_Director_Arms_NormalMap,
    ragdoll_arm_right_normalmap: sWilliam_Director_Arms_NormalMap,
    ragdoll_chest_top_normalmap: sWilliam_Knives_ChestTop_NormalMap,
    ragdoll_chest_bot_normalmap: sWilliam_Knives_ChestBot_NormalMap,
    ragdoll_leg_left_normalmap: sWilliam_Knives_LeftLeg_NormalMap,
    ragdoll_leg_right_normalmap: sWilliam_Knives_RightLeg_NormalMap,
}

// Knives
global.unit_sprite_packs[UnitSpritePacks.Knives] = 
{
    // Animation Sprites
    idle_sprite: sWilliam_Knives_Idle,
    walk_sprite: sWilliam_Knives_Run,
    jump_sprite: sWilliam_Knives_Jump,
    aim_sprite: sWilliam_Knives_Aim,
    aim_walk_sprite: sWilliam_Knives_AimWalk,

    // Animation NormalMaps
    idle_normalmap: sWilliam_Knives_Idle_NormalMap,
    walk_normalmap: sWilliam_Knives_Run_NormalMap,
    jump_normalmap: sWilliam_Knives_Jump_NormalMap,
    aim_normalmap: sWilliam_Knives_Aim_NormalMap,
    aim_walk_normalmap: sWilliam_Knives_AimWalk_NormalMap,
    
    // Bodypart Sprites
    ragdoll_head_sprite: sWilliam_Knives_Head,
    ragdoll_arm_left_sprite: sWilliam_Knives_Arms,
    ragdoll_arm_right_sprite: sWilliam_Knives_Arms,
    ragdoll_chest_top_sprite: sWilliam_Knives_ChestTop,
    ragdoll_chest_bot_sprite: sWilliam_Knives_ChestBot,
    ragdoll_leg_left_sprite: sWilliam_Knives_LeftLeg,
    ragdoll_leg_right_sprite: sWilliam_Knives_RightLeg,
    
    // Bodypart NormalMaps
    ragdoll_head_normalmap: sWilliam_Knives_Head_NormalMap,
    ragdoll_arm_left_normalmap: sWilliam_Knives_Arms_NormalMap,
    ragdoll_arm_right_normalmap: sWilliam_Knives_Arms_NormalMap,
    ragdoll_chest_top_normalmap: sWilliam_Knives_ChestTop_NormalMap,
    ragdoll_chest_bot_normalmap: sWilliam_Knives_ChestBot_NormalMap,
    ragdoll_leg_left_normalmap: sWilliam_Knives_LeftLeg_NormalMap,
    ragdoll_leg_right_normalmap: sWilliam_Knives_RightLeg_NormalMap,
}

// Martyr
global.unit_sprite_packs[UnitSpritePacks.Martyr] = 
{
    // Animation Sprites
    idle_sprite: sWilliamDS_Heavy_Idle,
    walk_sprite: sWilliamDS_Heavy_Run,
    jump_sprite: sWilliamDS_Heavy_Jump,
    aim_sprite: sWilliamDS_Heavy_Aim,
    aim_walk_sprite: sWilliamDS_Heavy_AimWalk,

    // Animation NormalMaps
    idle_normalmap: sWilliamDS_Heavy_Idle_NormalMap,
    walk_normalmap: sWilliamDS_Heavy_Run_NormalMap,
    jump_normalmap: sWilliamDS_Heavy_Jump_NormalMap,
    aim_normalmap: sWilliamDS_Heavy_Aim_NormalMap,
    aim_walk_normalmap: sWilliamDS_Heavy_AimWalk_NormalMap,
    
    // Bodypart Sprites
    ragdoll_head_sprite: sWilliamDS_Heavy_Head,
    ragdoll_arm_left_sprite: sWilliamDS_Heavy_Arms,
    ragdoll_arm_right_sprite: sWilliamDS_Heavy_Arms,
    ragdoll_chest_top_sprite: sWilliamDS_Heavy_ChestTop,
    ragdoll_chest_bot_sprite: sWilliamDS_Heavy_ChestBot,
    ragdoll_leg_left_sprite: sWilliamDS_Heavy_LeftLeg,
    ragdoll_leg_right_sprite: sWilliamDS_Heavy_RightLeg,
    
    // Bodypart NormalMaps
    ragdoll_head_normalmap: sWilliamDS_Heavy_Head_NormalMap,
    ragdoll_arm_left_normalmap: sWilliamDS_Heavy_Arms_NormalMap,
    ragdoll_arm_right_normalmap: sWilliamDS_Heavy_Arms_NormalMap,
    ragdoll_chest_top_normalmap: sWilliamDS_Heavy_ChestTop_NormalMap,
    ragdoll_chest_bot_normalmap: sWilliamDS_Heavy_ChestBot_NormalMap,
    ragdoll_leg_left_normalmap: sWilliamDS_Heavy_LeftLeg_NormalMap,
    ragdoll_leg_right_normalmap: sWilliamDS_Heavy_RightLeg_NormalMap,
}

// Northern Brigade Soldier
global.unit_sprite_packs[UnitSpritePacks.NorthernBrigadeSoldier] = 
{
    // Animation Sprites
    idle_sprite: sWilliam_NorthernBrigade_Soldat_Idle,
    walk_sprite: sWilliam_NorthernBrigade_Soldat_Run,
    jump_sprite: sWilliam_NorthernBrigade_Soldat_Jump,
    aim_sprite: sWilliam_NorthernBrigade_Soldat_Aim,
    aim_walk_sprite: sWilliam_NorthernBrigade_Soldat_AimWalk,

    // Animation NormalMaps
    idle_normalmap: sWilliam_NorthernBrigade_Soldat_Idle_NormalMap,
    walk_normalmap: sWilliam_NorthernBrigade_Soldat_Run_NormalMap,
    jump_normalmap: sWilliam_NorthernBrigade_Soldat_Jump_NormalMap,
    aim_normalmap: sWilliam_NorthernBrigade_Soldat_Aim_NormalMap,
    aim_walk_normalmap: sWilliam_NorthernBrigade_Soldat_AimWalk_NormalMap,
    
    // Bodypart Sprites
    ragdoll_head_sprite: sWilliam_NorthernBrigade_Soldat_Head,
    ragdoll_arm_left_sprite: sWilliam_NorthernBrigade_Arms,
    ragdoll_arm_right_sprite: sWilliam_NorthernBrigade_Arms,
    ragdoll_chest_top_sprite: sWilliam_NorthernBrigade_Soldat_ChestTop,
    ragdoll_chest_bot_sprite: sWilliam_NorthernBrigade_Soldat_ChestBot,
    ragdoll_leg_left_sprite: sWilliam_NorthernBrigade_LeftLeg,
    ragdoll_leg_right_sprite: sWilliam_NorthernBrigade_RightLeg,
    
    // Bodypart NormalMaps
    ragdoll_head_normalmap: sWilliam_NorthernBrigade_Soldat_Head_NormalMap,
    ragdoll_arm_left_normalmap: sWilliam_NorthernBrigade_Arms_NormalMap,
    ragdoll_arm_right_normalmap: sWilliam_NorthernBrigade_Arms_NormalMap,
    ragdoll_chest_top_normalmap: sWilliam_NorthernBrigade_Soldat_ChestTop_NormalMap,
    ragdoll_chest_bot_normalmap: sWilliam_NorthernBrigade_Soldat_ChestBot_NormalMap,
    ragdoll_leg_left_normalmap: sWilliam_NorthernBrigade_LeftLeg_NormalMap,
    ragdoll_leg_right_normalmap: sWilliam_NorthernBrigade_RightLeg_NormalMap,
}

// Northern Brigade Officer
global.unit_sprite_packs[UnitSpritePacks.NorthernBrigadeOfficer] = 
{
    // Animation Sprites
    idle_sprite: sWilliam_NorthernBrigade_Idle,
    walk_sprite: sWilliam_NorthernBrigade_Run,
    jump_sprite: sWilliam_NorthernBrigade_Jump,
    aim_sprite: sWilliam_NorthernBrigade_Aim,
    aim_walk_sprite: sWilliam_NorthernBrigade_AimWalk,

    // Animation NormalMaps
    idle_normalmap: sWilliam_NorthernBrigade_Idle_NormalMap,
    walk_normalmap: sWilliam_NorthernBrigade_Run_NormalMap,
    jump_normalmap: sWilliam_NorthernBrigade_Jump_NormalMap,
    aim_normalmap: sWilliam_NorthernBrigade_Aim_NormalMap,
    aim_walk_normalmap: sWilliam_NorthernBrigade_AimWalk_NormalMap,
    
    // Bodypart Sprites
    ragdoll_head_sprite: sWilliam_NorthernBrigade_Head,
    ragdoll_arm_left_sprite: sWilliam_NorthernBrigade_Arms,
    ragdoll_arm_right_sprite: sWilliam_NorthernBrigade_Arms,
    ragdoll_chest_top_sprite: sWilliam_NorthernBrigade_ChestTop,
    ragdoll_chest_bot_sprite: sWilliam_NorthernBrigade_ChestBot,
    ragdoll_leg_left_sprite: sWilliam_NorthernBrigade_LeftLeg,
    ragdoll_leg_right_sprite: sWilliam_NorthernBrigade_RightLeg,
    
    // Bodypart NormalMaps
    ragdoll_head_normalmap: sWilliam_NorthernBrigade_Head_NormalMap,
    ragdoll_arm_left_normalmap: sWilliam_NorthernBrigade_Arms_NormalMap,
    ragdoll_arm_right_normalmap: sWilliam_NorthernBrigade_Arms_NormalMap,
    ragdoll_chest_top_normalmap: sWilliam_NorthernBrigade_ChestTop_NormalMap,
    ragdoll_chest_bot_normalmap: sWilliam_NorthernBrigade_ChestBot_NormalMap,
    ragdoll_leg_left_normalmap: sWilliam_NorthernBrigade_LeftLeg_NormalMap,
    ragdoll_leg_right_normalmap: sWilliam_NorthernBrigade_RightLeg_NormalMap,
}


















