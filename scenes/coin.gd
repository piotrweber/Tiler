extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var colored_frames: SpriteFrames

var signals: CoinSignals
var value: int = 1
var _cell: Vector2i

func _ready() -> void:
	var tilemap := get_parent() as TileMapLayer
	if tilemap != null:
		_cell = tilemap.local_to_map(position)
		var room_id := get_tree().current_scene.scene_file_path.get_file().get_basename()
		var collected: Array = Vars.get_room_state(room_id).get("collected_coins", [])
		if _cell in collected:
			queue_free()
			return
	animated_sprite_2d.play("default")
	signals.collected.connect(_on_collected)

func colorize() -> void:
	if colored_frames != null:
		animated_sprite_2d.sprite_frames = colored_frames
		animated_sprite_2d.play("default")

func _on_collected() -> void:
	var room_id := get_tree().current_scene.scene_file_path.get_file().get_basename()
	var state := Vars.get_room_state(room_id)
	var collected: Array = state.get("collected_coins", [])
	if _cell not in collected:
		collected.append(_cell)
		state["collected_coins"] = collected
	Sigs.coin_collected.emit(value)
	queue_free()
