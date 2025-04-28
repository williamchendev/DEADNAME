/// @description Insert description here
// You can write your code in this editor

for (var i = 0; i < squad_num; i++)
{
	instance_create_layer
	(
		x, 
		y, 
		layer, 
		oDebugCreateSquad, 
		{
			squad_id: $"{self.squad_faction_id}_{id}_squad{i}",
			squad_faction_id: self.squad_faction_id,
			squad_leader_unit_pack: self.squad_leader_unit_pack,
			squad_unit_pack: self.squad_unit_pack
		}
	);
}

instance_destroy();