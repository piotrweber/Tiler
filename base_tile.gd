extends StaticBody2D
class_name BaseTile

## Fully self-contained tile. Signals up, gets called down

## Injected by the layer during setup
# The coordinates of the tilemap
var cell : Vector2i = Vector2i.ZERO
var neighbor_mask : int = 0
@export var sprite: Sprite2D
@export var bw_texture : Texture2D

var is_colored := false
var _colored_texture: Texture2D

# To what platform does this cell belong
var platform_id : int = -1
var map_layer : TileMapLayer
# When the player touches it
signal stepped_on(tile: BaseTile)
signal stepped_off(tile : BaseTile)
# The final revealed state is owned by the level
enum TileState { HIDDEN, VISIBLE, LOCKED }
var state : TileState = TileState.HIDDEN

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
# Ma
const COL_TEMPORARY := 0
const COL_LOCKED := 1
const MASK_TO_ROW := {
	0:  0,   # isolated (no neighbors)
	1:  1,   # bottom-cap  (neighbor above)
	2:  2,   # left-cap    (neighbor right)
	4:  3,   # top-cap     (neighbor below)
	5:  4,   # v-middle    (neighbors above + below)
	8:  5,   # right-cap   (neighbor left)
	10: 6,   # h-middle    (neighbors left + right)
}

func _ready() -> void:
	conceal()

func on_body_entered(body : Node2D):
	if body.is_in_group("player"):
		if body.velocity.y < 0:
			return
		stepped_on.emit(self)

func on_body_exited(body : Node2D):
	if body.is_in_group("player"):
		stepped_off.emit(self)

# API used by the layer
func setup(l_cell_pos: Vector2i, l_platform_id: int, p_mask: int) -> void:
	cell = l_cell_pos
	platform_id = l_platform_id
	neighbor_mask = p_mask
	area_2d.body_entered.connect(on_body_entered)
	area_2d.body_exited.connect(on_body_exited)

func preview():
	state = TileState.VISIBLE
	collision_shape_2d.set_deferred("disabled", false)
	update_sprite()

func lock():
	state = TileState.LOCKED
	collision_shape_2d.set_deferred("disabled", false)
	update_sprite()

func conceal():
	state = TileState.HIDDEN
	#lock_sprite.hide()
	#preview_sprite.hide()
	collision_shape_2d.set_deferred("disabled", true)
	update_sprite()

func reveal():
	state = TileState.VISIBLE
	update_sprite()

func colorize(tex: Texture2D) -> void:
	is_colored = true
	_colored_texture = tex
	update_sprite()

# Display
func update_sprite() -> void:
	sprite.visible = state != TileState.HIDDEN
	if not sprite.visible:
		return
	sprite.texture = _colored_texture if is_colored else bw_texture
	sprite.region_enabled = true
	var row : int = MASK_TO_ROW.get(neighbor_mask, 0)
	var col := 0 if is_colored else (COL_LOCKED if state == TileState.LOCKED else COL_TEMPORARY)
	sprite.region_rect = Rect2(col * Vars.TILE_SIZE, row * Vars.TILE_SIZE, Vars.TILE_SIZE, Vars.TILE_SIZE)
