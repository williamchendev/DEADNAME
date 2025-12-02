/// @description Default Planet Clean Up
// Cleans up the Planet's Data Structures and Buffers used for calculating the Planet's Behaviour

// Delete Icosphere Vertex Buffer
vertex_delete_buffer(icosphere_vertex_buffer);
icosphere_vertex_buffer = -1;
