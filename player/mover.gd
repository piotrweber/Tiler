extends Node
class_name Mover

@export_group("Horizontal")
@export_range(10.0,1000.0,10) var move_ground_velocity = 500.0
@export_range(10.0,1000.0,10) var move_air_velocity = 100.0
@export_range(10.0,5000.0,10) var acceleration = 1500.0
@export_range(10.0,5000.0,10) var friction = 2000.0
@export_range(0.0,1.0,0.05) var air_damping = 0.2

@export_group("Vertical")
@export_range(100.0,3000.0,10) var gravity = 980.0
@export_range(100.0,3000.0,10) var fall_gravity = 3000.0
@export_range(100.0,5000.0,10) var fast_fall_gravity = 5000.0
@export_range(0.0,50.0,1) var wall_gravity = 25.0
@export_range(1.0,10.0,0.5) var jump_cut_gravity_scale = 3.0
@export_range(100.0,1000.0,10) var jump_velocity = -700.0
@export_range(100.0,1000.0,10) var wall_jump_velocity = -700.0
@export_range(100.0,1000.0,10) var wall_jump_pushback = 300.0
@export_range(0.1,1.0,0.10) var input_buffer_patience = 0.1
@export_range(0.01,1.0) var coyote_time = 0.08
@export_range(0.05,2.0,0.05) var double_jump_window = 0.5

var input_timer : Timer
var coyote_timer : Timer
var double_jump_timer : Timer
var is_coyote_ready : bool = true
var can_double_jump : bool = false
var parent : Player

func _enter_tree() -> void:
	owner.mover = self
	parent = get_parent()

func _ready() -> void:
	setup_timers()

func setup_timers():
	input_timer = Timer.new()
	input_timer.wait_time = input_buffer_patience
	input_timer.one_shot = true
	add_child(input_timer)

	coyote_timer = Timer.new()
	coyote_timer.wait_time = coyote_time
	coyote_timer.one_shot = true
	add_child(coyote_timer)
	coyote_timer.timeout.connect(on_coyote_timer_timeout)

	double_jump_timer = Timer.new()
	double_jump_timer.wait_time = double_jump_window
	double_jump_timer.one_shot = true
	add_child(double_jump_timer)
	double_jump_timer.timeout.connect(func(): can_double_jump = false)

func on_coyote_timer_timeout():
	is_coyote_ready = false

func move_x(current_x: float, horizontal_input: float, delta: float) -> float:
	var dasher: Dasher = owner.dasher
	if dasher != null:
		dasher.update_direction(horizontal_input)
	var damping = 1.0 if parent.is_on_floor() else air_damping
	var dash_mult = dasher.dash_speed_multiplier if dasher != null and dasher.is_dashing else 1.0
	var target_speed = move_ground_velocity if parent.is_on_floor() else move_air_velocity
	if horizontal_input != 0.0:
		return move_toward(current_x, horizontal_input * target_speed * dash_mult, acceleration * delta)
	else:
		return move_toward(current_x, 0.0, friction * damping * delta)

func get_gravity(horizontal_input: float) -> float:
	if Input.is_action_pressed("fast_fall"):
		return fast_fall_gravity
	if parent.is_on_wall_only() and parent.velocity.y > 0 and horizontal_input != 0:
		return wall_gravity
	if parent.velocity.y < 0 and not Input.is_action_pressed("jump"):
		return gravity * jump_cut_gravity_scale
	return gravity if parent.velocity.y < 0 else fall_gravity
