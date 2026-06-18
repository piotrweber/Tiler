extends TileMapLayer
class_name PlatformTileLayer
## The layer gets info from the tiles and pushed down decisions
## Owns the state. 
## Children are services that modify the state

## Vector2i -> Basetile
var tiles_by_cell: Dictionary = {}
## [{cells, stepped: Dictionary, locked: bool}]
var platforms : Array = [] 
var current_platform : int = -1
var locked_count : int = 0

# References
@onready var discovery: PlatformDiscovery = $Discovery
@onready var rules: PlatformRules = $Rules
@onready var persistence: PlatformPersistence = $Persistence
 

func _ready() -> void:
	# Make sure all init on every cell is done
	init_level.call_deferred()

func init_level():
	discovery.build(self)
	persistence.restore(self)
	_resolve_traps()
	for tile : BaseTile in tiles_by_cell.values():
		tile.stepped_on.connect(rules.on_tile_stepped_on)
		tile.stepped_off.connect(rules.on_tile_stepped_off)
	Sigs.platform_layer_ready.emit(self)

func _resolve_traps() -> void:
	for platform in platforms:
		var trap_cell := Vector2i(-1, -1)
		for cell : Vector2i in platform.cells:
			if tiles_by_cell[cell] is TrapTile:
				trap_cell = cell
				break
		if trap_cell == Vector2i(-1, -1):
			continue
		var trap_tile := tiles_by_cell[trap_cell] as TrapTile
		if not trap_tile.randomize_position:
			continue
		var candidates: Array = platform.cells.filter(func(c): return not (tiles_by_cell[c] is TrapTile))
		if candidates.is_empty():
			continue
		var target_cell: Vector2i = candidates.pick_random()
		var regular_tile := tiles_by_cell[target_cell] as BaseTile
		tiles_by_cell[trap_cell] = regular_tile
		tiles_by_cell[target_cell] = trap_tile
		var tmp_pos := trap_tile.position
		trap_tile.position = regular_tile.position
		regular_tile.position = tmp_pos
		trap_tile.cell = target_cell
		regular_tile.cell = trap_cell
		var tmp_mask := trap_tile.neighbor_mask
		trap_tile.neighbor_mask = regular_tile.neighbor_mask
		regular_tile.neighbor_mask = tmp_mask

func get_save_state() -> Dictionary:
	return Vars.get_room_state(
		get_tree().current_scene.scene_file_path.get_file().get_basename()
	)
