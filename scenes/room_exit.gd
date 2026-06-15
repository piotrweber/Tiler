extends Area2D

@export var target_scene_path: String
@export var target_spawn: String = "default"
@export var carry_velocity: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	assert(not target_scene_path.is_empty(), str(name, ": target_scene_path is not set in the inspector"))
	SceneManager.pending_spawn = target_spawn
	if carry_velocity:
		SceneManager.has_pending_velocity = true
		SceneManager.pending_velocity = (body as CharacterBody2D).velocity
	else:
		SceneManager.has_pending_velocity = false
		SceneManager.pending_velocity = Vector2.ZERO
	var packed := load(target_scene_path) as PackedScene
	get_tree().call_deferred(&"change_scene_to_packed", packed)
