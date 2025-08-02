//
enum HandItemPack
{
    None,
    DebugHeldItem,
    FAL_Magazine,
    Sword
}

// None
global.hand_item_pack[UnitHeldItem.None] = 
{
    // Held Item Sprite
    hand_item_sprite_index: noone,
    hand_item_normalmap_index: noone,
    hand_item_image_index: 0
}

// DebugItem
global.hand_item_pack[UnitHeldItem.DebugHeldItem] =
{
    // Held Item Sprite
    hand_item_sprite_index: sHeldItems,
    hand_item_normalmap_index: sHeldItems,
    hand_item_image_index: 0
};

// Magazine
global.hand_item_pack[UnitHeldItem.FAL_Magazine] =
{
    // Held Item Sprite
    hand_item_sprite_index: sArkov_FAL_Magazine_HeldItem,
    hand_item_normalmap_index: sArkov_FAL_Magazine_NormalMap_HeldItem,
    hand_item_image_index: 0
};

// Sword
global.hand_item_pack[UnitHeldItem.Sword] =
{
    // Held Item Sprite
    hand_item_sprite_index: sHeldItem_Sword,
    hand_item_normalmap_index: sHeldItem_Sword,
    hand_item_image_index: 0
};
