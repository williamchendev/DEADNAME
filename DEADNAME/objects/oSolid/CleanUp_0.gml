/// @description Solid Cleanup Event
// Deletes Shadow Vertex Buffer from Memory

// Check if Shadows Exist
if (!shadows_enabled)
{
	return;
}

// Delete Shadow Vertex Buffer
vertex_delete_buffer(shadow_vertex_buffer);
shadow_vertex_buffer = -1;
