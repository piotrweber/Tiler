extends Node2D

func _ready() -> void:
	var player := get_tree().get_first_node_in_group("player") as CharacterBody2D
	if player == null:
		return
	var spawn_points := get_node_or_null("SpawnPoints") as Node2D
	if spawn_points == null:
		return
	var spawn := spawn_points.get_node_or_null(SceneManager.pending_spawn) as Node2D
	var target := spawn if spawn != null else spawn_points.get_child(0) as Node2D
	if target != null:
		player.global_position = target.global_position
	if SceneManager.has_pending_velocity:
		player.velocity = SceneManager.pending_velocity
		SceneManager.has_pending_velocity = false
		SceneManager.pending_velocity = Vector2.ZERO
