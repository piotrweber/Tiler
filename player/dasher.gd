extends Node
class_name Dasher

@export_group("Dash")
@export_range(1.0, 5.0, 0.5) var dash_speed_multiplier: float = 2.0
@export_range(0.05, 1.0, 0.05) var dash_duration: float = 0.2
@export var brake_curve: Curve
@export_range(100.0, 30000.0, 100.0) var brake_deceleration: float = 10000.0
@export_range(0.5, 5.0, 0.5) var brake_tile_count: float = 1.5

signal dash_started
signal dash_ended

var is_dashing: bool = false
var dash_target_x: float = NAN
var snap_x: float = NAN
var brake_zone_width: float = 0.0
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
	_dash_timer.timeout.connect(end_dash)
	Sigs.platform_layer_ready.connect(func(l): _platform_layer = l)

func update_direction(horizontal_input: float) -> void:
	if horizontal_input != 0.0:
		last_h_direction = sign(horizontal_input)

func try_dash() -> void:
	snap_x = NAN
	if not Input.is_action_just_pressed("dash") or is_dashing:
		return
	is_dashing = true
	_calculate_target()
	_dash_timer.start(dash_duration)
	dash_started.emit()

func end_dash() -> void:
	if not is_dashing:
		return
	_dash_timer.stop()
	dash_target_x = NAN
	brake_zone_width = 0.0
	is_dashing = false
	dash_ended.emit()

func apply_snap(body: CharacterBody2D) -> void:
	if is_nan(snap_x):
		return
	body.global_position.x = snap_x
	snap_x = NAN

func _calculate_target() -> void:
	if not _parent.is_on_floor() or _platform_layer == null or _platform_layer.current_platform < 0:
		dash_target_x = NAN
		brake_zone_width = 0.0
		return
	var platform: Dictionary = _platform_layer.platforms[_platform_layer.current_platform]
	if platform.is_locked:
		dash_target_x = NAN
		brake_zone_width = 0.0
		return
	var cells: Array = platform.cells
	var tile_w: float = _platform_layer.tile_set.tile_size.x
	var edge_x: int = cells[0].x
	for c in cells:
		edge_x = max(edge_x, c.x) if last_h_direction > 0 else min(edge_x, c.x)
	var edge_world = _platform_layer.to_global(_platform_layer.map_to_local(Vector2i(edge_x, 0)))
	dash_target_x = edge_world.x + tile_w * 0.5 * last_h_direction
	brake_zone_width = tile_w * brake_tile_count
