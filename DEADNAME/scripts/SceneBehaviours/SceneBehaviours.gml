// Scene Enums
enum SceneType
{
    Title,
    WorldMap,
    Platformer
}

//
function scene_get_type()
{
    // Initialize Scene Type
    var temp_scene_type = undefined;
    
    // Find Scene Type based on Room Name
    switch (room_get_name(room))
    {
        case "_TitleScreen":
            // Title Screen
            temp_scene_type = SceneType.Title;
            break;
        default:
            // Platformer Level
            temp_scene_type = SceneType.Platformer;
            break;
    }
    
    // Return Scene Type
    return temp_scene_type;
}

