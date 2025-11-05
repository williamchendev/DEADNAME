/// @description Icosphere Initialization
// Creates the Icosphere Vertex Buffer

// Begin Initialize Vertex Buffer
icosphere_vertex_buffer = vertex_create_buffer();
vertex_begin(icosphere_vertex_buffer, oLightingEngine.lighting_engine_icosphere_render_vertex_format);

//


// Finish Initializing Vertex Buffer
vertex_end(icosphere_vertex_buffer);
vertex_freeze(icosphere_vertex_buffer);

