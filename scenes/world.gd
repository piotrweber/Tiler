extends Node2D

@export var starting_room: String
@export var rooms: Array[PackedScene]
@onready var _room_container: Node2D = $RoomContainer

func _ready() -> void:
	SceneManager.room_container = _room_container
	for scene in rooms:
		var id := scene.resource_path.get_file().get_basename()
		SceneManager._rooms[id] = scene
	SceneManager.go_to_room(starting_room, "default")
