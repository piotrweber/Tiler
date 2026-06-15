extends Node
class_name PlatformPersistence

func _room_id() -> String:
	return get_tree().current_scene.scene_file_path.get_file().get_basename()

func save_locked(platform_id: int) -> void:
	var state := Vars.get_room_state(_room_id())
	var locked: Array = state.get("locked_platforms", [])
	if platform_id not in locked:
		locked.append(platform_id)
		state["locked_platforms"] = locked

func restore(layer: PlatformTileLayer) -> void:
	var locked_ids: Array = Vars.get_room_state(_room_id()).get("locked_platforms", [])
	for platform_id in locked_ids:
		if platform_id >= layer.platforms.size():
			continue
		var platform: Dictionary = layer.platforms[platform_id]
		platform.is_locked = true
		for cell: Vector2i in platform.cells:
			layer.tiles_by_cell[cell].restore_lock()
		layer.locked_count += 1
