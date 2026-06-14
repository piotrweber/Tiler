extends Node
class_name Dasher

@export_group("Dash")
@export_range(1.0, 5.0, 0.5) var dash_speed_multiplier: float = 2.0
@export_range(0.05, 1.0, 0.05) var dash_duration: float = 0.2

signal dash_started
signal dash_ended

var is_dashing: bool = false
var dash_target_x: float = NAN
var last_h_direction: float = 1.0

var _parent: CharacterBody2D
var _platform_layer: PlatformTileLayer = null
var _dash_timer: Timer

func _enter_tree() -> void:
	owner.dasher = self
	_parent = get_parent()

func _ready() -> void:
	_dash_timer = Timer.new()
	_dash_timer.wait_time = dash_duration
	_dash_timer.one_shot = true
	add_child(_dash_timer)
	_dash_timer.timeout.connect(_on_dash_ended)
	Sigs.platform_layer_ready.connect(func(l): _platform_layer = l)

func update_direction(horizontal_input: float) -> void:
	if horizontal_input != 0.0:
		last_h_direction = sign(horizontal_input)

func try_dash() -> void:
	if not Input.is_action_just_pressed("dash") or is_dashing:
		return
	is_dashing = true
	_dash_timer.start(dash_duration)
	_calculate_target()
	dash_started.emit()

func clamp_to_target() -> void:
	if not is_dashing or is_nan(dash_target_x):
		return
	var overshot = (last_h_direction > 0 and _parent.global_position.x >= dash_target_x) \
				or (last_h_direction < 0 and _parent.global_position.x <= dash_target_x)
	if overshot:
		_parent.global_position.x = dash_target_x
		dash_target_x = NAN
		_dash_timer.stop()
		_on_dash_ended()

func _calculate_target() -> void:
	if not _parent.is_on_floor() or _platform_layer == null or _platform_layer.current_platform < 0:
		dash_target_x = NAN
		return
	var cells: Array = _platform_layer.platforms[_platform_layer.current_platform].cells
	var tile_w: float = _platform_layer.tile_set.tile_size.x
	var edge_x: int = cells[0].x
	for c in cells:
		edge_x = max(edge_x, c.x) if last_h_direction > 0 else min(edge_x, c.x)
	var edge_world = _platform_layer.to_global(_platform_layer.map_to_local(Vector2i(edge_x, 0)))
	dash_target_x = edge_world.x + tile_w * 0.5 * last_h_direction

func _on_dash_ended() -> void:
	is_dashing = false
	dash_ended.emit()
