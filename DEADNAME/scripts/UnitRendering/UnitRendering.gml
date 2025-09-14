/// unit_render_behaviour(unit);
/// @description Draws the given Unit Instance using the Deferred Lighting Engine's Multi-Render-Target System using a Diffuse/Normal/Metallic/Roughness/Emissive workflow
/// @param {?Id.Instance, oUnit} unit The given Unit Instance to render
function unit_render_behaviour(unit)
{
	with (unit)
	{
		// Rendering Enabled Check
		if (!render_enabled)
		{
			break;
		}
		
		// Draw Secondary Arm rendered behind Unit Body
		limb_secondary_arm.render_behaviour();
		
		// Draw Unit's Back-Layer Inventory Items
		var temp_back_inventory_slot_index = 0;
		
		repeat (array_length(inventory_slots))
		{
			// Check if Inventory Item can be Drawn
			if (inventory_slots[temp_back_inventory_slot_index].item_pack != ItemPack.None and temp_back_inventory_slot_index != inventory_index and inventory_slots[temp_back_inventory_slot_index].slot_render_order == UnitInventorySlotRenderOrder.Back)
			{
				// Render Slot's Inventory Item
				inventory_slots[temp_back_inventory_slot_index].item_instance.render_behaviour();
			}
			
			// Increment Inventory Slot Index
			temp_back_inventory_slot_index++;
		}
		
		// Draw Unit Body
		lighting_engine_render_sprite_ext
		(
			sprite_index,
			image_index,
			normalmap_spritepack != undefined ? normalmap_spritepack[image_index].texture : undefined,
			metallicroughnessmap_spritepack != undefined ? metallicroughnessmap_spritepack[image_index].texture : undefined,
			emissivemap_spritepack != undefined ? emissivemap_spritepack[image_index].texture : undefined,
			normalmap_spritepack != undefined ? normalmap_spritepack[image_index].uvs : undefined,
			metallicroughnessmap_spritepack != undefined ? metallicroughnessmap_spritepack[image_index].uvs : undefined,
			emissivemap_spritepack != undefined ? emissivemap_spritepack[image_index].uvs : undefined,
			normal_strength,
			metallic,
			roughness,
			emissive,
			emissive_multiplier,
			x,
			y + ground_contact_vertical_offset,
			draw_xscale,
			draw_yscale,
			image_angle + draw_angle_value,
			image_blend,
			image_alpha
		);
		
		// Draw Unit's Front-Layer Inventory Items
		var temp_front_inventory_slot_index = 0;
		
		repeat (array_length(inventory_slots))
		{
			// Check if Inventory Item can be Drawn
			if (inventory_slots[temp_front_inventory_slot_index].item_pack != ItemPack.None and temp_front_inventory_slot_index != inventory_index and inventory_slots[temp_front_inventory_slot_index].slot_render_order == UnitInventorySlotRenderOrder.Front)
			{
				// Render Slot's Inventory Item
				inventory_slots[temp_front_inventory_slot_index].item_instance.render_behaviour();
			}
			
			// Increment Inventory Slot Index
			temp_front_inventory_slot_index++;
		}
		
		// Draw Unit's Equipped Item
		if (equipment_active)
		{
			item_equipped.render_behaviour();
		}
		
		// Draw Primary Arm rendered in front Unit Body
		limb_primary_arm.render_behaviour();
	}
}

/// unit_render_behaviour(unit);
/// @description Draws the given Unit Instance unlit
/// @param {?Id.Instance, oUnit} unit The given Unit Instance to render
/// @param {real} x_offset The horizontal offset to draw the given Unit Instance with
/// @param {real} y_offset The vertical offset to draw the given Unit Instance with
function unit_unlit_render_behaviour(unit, x_offset = 0, y_offset = 0)
{
	with (unit)
	{
		// Draw Secondary Arm rendered behind Unit Body
		limb_secondary_arm.render_unlit_behaviour(x_offset, y_offset);
		
		// Draw Unit's Back-Layer Inventory Items
		var temp_back_inventory_slot_index = 0;
		
		repeat (array_length(inventory_slots))
		{
			// Check if Inventory Item can be Drawn
			if (inventory_slots[temp_back_inventory_slot_index].item_pack != ItemPack.None and temp_back_inventory_slot_index != inventory_index and inventory_slots[temp_back_inventory_slot_index].slot_render_order == UnitInventorySlotRenderOrder.Back)
			{
				// Render Slot's Inventory Item
				inventory_slots[temp_back_inventory_slot_index].item_instance.render_unlit_behaviour(x_offset, y_offset);
			}
			
			// Increment Inventory Slot Index
			temp_back_inventory_slot_index++;
		}
		
		// Draw Unit Body
		draw_sprite_ext(sprite_index, image_index, x + x_offset, y + ground_contact_vertical_offset + y_offset, draw_xscale, draw_yscale, image_angle + draw_angle_value, image_blend, image_alpha);
		
		// Draw Unit's Front-Layer Inventory Items
		var temp_front_inventory_slot_index = 0;
		
		repeat (array_length(inventory_slots))
		{
			// Check if Inventory Item can be Drawn
			if (inventory_slots[temp_front_inventory_slot_index].item_pack != ItemPack.None and temp_front_inventory_slot_index != inventory_index and inventory_slots[temp_front_inventory_slot_index].slot_render_order == UnitInventorySlotRenderOrder.Front)
			{
				// Render Slot's Inventory Item
				inventory_slots[temp_front_inventory_slot_index].item_instance.render_unlit_behaviour(x_offset, y_offset);
			}
			
			// Increment Inventory Slot Index
			temp_front_inventory_slot_index++;
		}
		
		// Draw Unit's Weapon (if equipped)
		if (equipment_active)
		{
			item_equipped.render_unlit_behaviour(x_offset, y_offset);
		}
		
		// Draw Primary Arm rendered in front Unit Body
		limb_primary_arm.render_unlit_behaviour(x_offset, y_offset);
	}
}

