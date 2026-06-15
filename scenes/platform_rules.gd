extends Node
class_name PlatformRules

## Rules for tile visiblity

@onready var layer: PlatformTileLayer = get_parent()

func on_tile_stepped_on(tile : BaseTile):
	var platform : Dictionary = layer.platforms[tile.platform_id]

	if platform.is_locked:
		return

	platform.stepped[tile.cell] = true
	tile.preview()

	# If the player stepped on all tiles
	if platform.stepped.size() == platform.cells.size():
		lock_platform(tile.platform_id)

func on_tile_stepped_off(_tile : BaseTile):
	# Preview persists until the player lands on a different platform
	pass

func lock_platform(platform_id : int):
	var platform : Dictionary = layer.platforms[platform_id]
	
	if platform.is_locked:
		return
	
	platform.is_locked = true
	
	# lock all cells in platform
	for cell: Vector2i in platform.cells:
		layer.tiles_by_cell[cell].lock()
	
	count_locked_platforms()
	

func count_locked_platforms():
	layer.locked_count += 1
	if layer.locked_count == layer.platforms.size():
		_complete_level()

func _complete_level() -> void:
	Sigs.level_completed.emit()

	
