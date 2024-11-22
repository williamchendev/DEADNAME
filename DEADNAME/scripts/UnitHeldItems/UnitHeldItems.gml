//
enum UnitHeldItem
{
    None,
    DebugHeldItem,
    FAL_Magazine,
    Sword
}

// None
global.unit_held_items[UnitHeldItem.None] = 
{
    // Held Item Sprite
    item_sprite_index: noone,
    item_normalmap_index: noone,
    item_image_index: 0
}

// DebugItem
global.unit_held_items[UnitHeldItem.DebugHeldItem] =
{
    // Held Item Sprite
    item_sprite_index: sArkov_FAL_Magazine,
    item_normalmap_index: sArkov_FAL_Magazine,
    item_image_index: 0
}

// Magazine
global.unit_held_items[UnitHeldItem.FAL_Magazine] =
{
    // Held Item Sprite
    item_sprite_index: sArkov_FAL_Magazine,
    item_normalmap_index: sArkov_FAL_Magazine,
    item_image_index: 0
}

// Sword
global.unit_held_items[UnitHeldItem.Sword] =
{
    // Held Item Sprite
    item_sprite_index: sHeldItem_Sword,
    item_normalmap_index: sHeldItem_Sword,
    item_image_index: 0
}
