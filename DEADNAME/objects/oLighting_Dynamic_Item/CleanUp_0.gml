/// @description Default Dynamic Item Cleanup Event
// Deletes the Default Dynamic Item's Simulated Instance from Memory

if (item_instance != noone)
{
	DELETE(item_instance);
}
