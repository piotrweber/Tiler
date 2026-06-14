extends StaticBody2D
class_name BaseTile

## Fully self-contained tile. Signals up, gets called down

## Injected by the layer during setup
# The coordinates of the tilemap
var cell : Vector2i = Vector2i.ZERO
# To what platform does this cell belong
var platform_id : int = -1
var map_layer : TileMapLayer
# When the player touches it
signal stepped_on(tile: BaseTile)
signal stepped_off(tile : BaseTile)
# The final revealed state is owned by the level
enum TileState { HIDDEN, VISIBLE, LOCKED }
var state : TileState = TileState.HIDDEN
@onready var lock_sprite: Sprite2D = $Lock
@onready var preview_sprite: Sprite2D = $Preview
@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	lock_sprite.hide()
	conceal()

func on_body_entered(body : Node2D):
	if body.is_in_group("player"):
		stepped_on.emit(self)

func on_body_exited(body : Node2D):
	if body.is_in_group("player"):
		stepped_off.emit(self)

# API used by the layer
func setup(l_cell_pos: Vector2i, l_platform_id: int, _p_mask: int) -> void:
	cell = l_cell_pos
	platform_id = l_platform_id
	area_2d.body_entered.connect(on_body_entered)
	area_2d.body_exited.connect(on_body_exited)

func preview():
	lock_sprite.hide()
	preview_sprite.show()
	# wait for physics step to complete
	collision_shape_2d.set_deferred("disabled", false)

func lock():
	lock_sprite.show()
	preview_sprite.hide()
	# wait for physics step to complete
	collision_shape_2d.set_deferred("disabled", false)

func conceal():
	lock_sprite.hide()
	preview_sprite.hide()
	# wait for physics step to complete
	collision_shape_2d.set_deferred("disabled", true)
	
func reveal():
	state = TileState.VISIBLE

	
# Display
func _update_sprite():
	pass
	
