extends Node

@export var dash_ghost_scene : PackedScene
@export_range(0.01, 0.2, 0.01) var ghost_interval : float = 0.05
@export_range(0.05, 1.0, 0.05) var ghost_duration : float = 0.2

var _player : CharacterBody2D
var _sprite : Sprite2D
var _spawn_timer : Timer

func _ready() -> void:
	_player = get_parent()
	_sprite = _player.get_node("Sprite2D")

	_spawn_timer = Timer.new()
	_spawn_timer.wait_time = ghost_interval
	_spawn_timer.one_shot = false
	add_child(_spawn_timer)
	_spawn_timer.timeout.connect(_spawn_ghost)

	_player.dasher.dash_started.connect(_on_dash_started)
	_player.dasher.dash_ended.connect(_on_dash_ended)

func _on_dash_started() -> void:
	_spawn_ghost()
	_spawn_timer.start()

func _on_dash_ended() -> void:
	_spawn_timer.stop()

func _spawn_ghost() -> void:
	var ghost : DashSprite = dash_ghost_scene.instantiate()
	ghost.init(_sprite, _player.global_position, ghost_duration)
	_player.get_parent().add_child(ghost)
	ghost.global_position = _player.global_position
