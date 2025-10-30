/// @description Explosion Init Event
// Creates the Explosion Effect and all of the Object Instances necessary for it

// Set Unlit Object Type for Unlit Object Initialization in the Lighting Engine
object_type = LightingEngineUnlitObjectType.Default;

//
object_depth = -0.01;

// Lighting Engine Default Dynamic Object Initialization
event_inherited();
