/// @description Default Celestial Body Clean Up
// Cleans up the Celestial Body's Data Structures and Buffers used for calculating the Celestial Body's Behaviour

// Delete Icosphere Vertex Buffer
vertex_delete_buffer(icosphere_vertex_buffer);
icosphere_vertex_buffer = -1;

