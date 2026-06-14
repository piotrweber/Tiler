extends Node
class_name PlatformRules

## Rules for tile visiblity

@onready var layer: PlatformTileLayer = get_parent()

func on_tile_stepped_on(tile : BaseTile):
	var platform : Dictionary = layer.platforms[tile.platform_id]

	if layer.current_platform != tile.platform_id:
		conceal_platform(layer.current_platform)
		layer.current_platform = tile.platform_id

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
	

func conceal_platform(id: int) -> void:
	if id < 0:
		return
	var p: Dictionary = layer.platforms[id]
	if p.is_locked:
		return
	p.stepped.clear()
	for cell: Vector2i in p.cells:
		var tile: BaseTile = layer.tiles_by_cell[cell]
		tile.conceal()
		
func count_locked_platforms():
	layer.locked_count += 1
	if layer.locked_count == layer.platforms.size():
		_complete_level()

func _complete_level() -> void:
	print_debug("level complete!")

	
