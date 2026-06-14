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
	for tile : BaseTile in tiles_by_cell.values():
		tile.stepped_on.connect(rules.on_tile_stepped_on)
		tile.stepped_off.connect(rules.on_tile_stepped_off)

func get_save_state():
	pass
	
func apply_save_sate():
	pass
