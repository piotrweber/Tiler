extends Node

const TILE_SIZE : int = 32

var room_states: Dictionary = {}

func get_room_state(room_id: String) -> Dictionary:
	if not room_states.has(room_id):
		room_states[room_id] = {}
	return room_states[room_id]

func _ready() -> void:
	Sigs.coin_collected.connect(func(value): Vars.coins = value)

var coins : int = 0:
	set(value):
		if value > 0:
			coins += value
			Sigs.coin_value_updated.emit()
