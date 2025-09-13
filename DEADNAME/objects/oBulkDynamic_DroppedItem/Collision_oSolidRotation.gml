/// @description oSolidRotation Collision Event
// Event exists to allow the Shell Casing Entity to collide with Solid Objects

// Check if Physics Object has fallen on to a Solid Collider
if (phy_speed > 0.15 and place_free(x, y + 1))
{
    return;
}

// Upon Solid Collision Add Dynamic Object to Bulk Dynamic Layer's Vertex Buffer
add_dynamic_object_to_bulk_sprite_vertex_buffer(id);

// Destroy Instance
instance_destroy();
