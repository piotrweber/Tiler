extends CharacterBody2D
class_name Player

var mover : Mover = null
var dasher : Dasher = null
var state_machine : StateMachine = null
var dash_sprite : DashSprite

var is_invulnerable: bool:
	get: return dasher != null and dasher.is_dashing

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	state_machine.init(self, mover, sprite, dasher)
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	if dasher != null:
		sprite.flip_h = dasher.last_h_direction < 0
