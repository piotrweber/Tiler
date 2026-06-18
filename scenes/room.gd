extends Node2D

@export var theme: LevelTheme

var _tile_layer: PlatformTileLayer

func _ready() -> void:
	SceneManager.current_room_id = scene_file_path.get_file().get_basename()
	var player := get_tree().get_first_node_in_group("player") as CharacterBody2D
	if player != null:
		var spawn_points := get_node_or_null("SpawnPoints") as Node2D
		if spawn_points != null:
			var spawn := spawn_points.get_node_or_null(SceneManager.pending_spawn) as Node2D
			var target := spawn if spawn != null else spawn_points.get_child(0) as Node2D
			if target != null:
				player.global_position = target.global_position
		if SceneManager.has_pending_velocity:
			player.velocity = SceneManager.pending_velocity
			SceneManager.has_pending_velocity = false
			SceneManager.pending_velocity = Vector2.ZERO
	Sigs.platform_layer_ready.connect(func(layer: PlatformTileLayer) -> void:
		_tile_layer = layer
		_restore_colored()
		for tile : BaseTile in layer.tiles_by_cell.values():
			tile.trap_triggered.connect(_on_trap_triggered)
	)
	if theme != null:
		Sigs.level_completed.connect(_on_level_completed)

func _swap_themed_layers(tex: Texture2D) -> void:
	for node in get_tree().get_nodes_in_group("themed_layers"):
		var layer := node as TileMapLayer
		for idx in range(layer.tile_set.get_source_count()):
			var src := layer.tile_set.get_source(layer.tile_set.get_source_id(idx)) as TileSetAtlasSource
			if src:
				src.texture = tex

func _restore_colored() -> void:
	if theme == null:
		return
	if not Vars.get_room_state(SceneManager.current_room_id).get("is_colored", false):
		return
	var bg := get_node_or_null("ColorRect") as ColorRect
	if bg != null:
		bg.color = theme.background_color
	for tile in _tile_layer.tiles_by_cell.values():
		(tile as BaseTile).restore_color(theme.tile_colored_texture)
	for coin in get_tree().get_nodes_in_group("coins"):
		if coin.has_method("colorize"):
			coin.colorize()
	_swap_themed_layers(theme.tile_colored_texture)

func _on_trap_triggered(_tile: BaseTile) -> void:
	var packed := load(scene_file_path) as PackedScene
	get_tree().call_deferred(&"change_scene_to_packed", packed)

func _on_level_completed() -> void:
	Vars.get_room_state(SceneManager.current_room_id)["is_colored"] = true
	var bg := get_node_or_null("ColorRect") as ColorRect
	if bg != null:
		var tween := create_tween()
		tween.tween_property(bg, "color", theme.background_color, 1.0)
	if _tile_layer != null:
		for tile in _tile_layer.tiles_by_cell.values():
			(tile as BaseTile).colorize(theme.tile_colored_texture)
	for coin in get_tree().get_nodes_in_group("coins"):
		if coin.has_method("colorize"):
			coin.colorize()
	_swap_themed_layers(theme.tile_colored_texture)
