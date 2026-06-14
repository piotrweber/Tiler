extends Node
class_name Mover

@export_range(2000.0,3000.0,10) var gravity = 2000.0
@export_range(2000.0,3000.0,10) var fall_gravity = 3000.0
@export_range(2000.0,5000.0,10) var fast_fall_gravity = 5000.0
@export_range(10.0,50.0,1) var wall_gravity = 25.0

@export_range(100.0,1000.0,10) var jump_velocity = -700.0
@export_range(100.0,1000.0,10) var wall_jump_velocity = -700.0
@export_range(100.0,1000.0,10) var wall_jump_pushback = 300.0

@export_range(0.0,1.0,0.10) var input_buffer_patience = 1.0
@export_range(0.0,1.0) var coyote_time = 0.08

var input_buffer : Timer
var coyote_timer : Timer
var coyote_jump_ready : bool

func _enter_tree() -> void:
	owner.mover = self

func _ready() -> void:
	setup_timers()
	
func setup_timers():
	# Input buffer
	input_buffer = Timer.new()
	input_buffer.wait_time = input_buffer_patience
	input_buffer.one_shot
	add_child(input_buffer)
	
	# Coyote timer
	coyote_timer = Timer.new()
	coyote_timer.wait_time = coyote_time
	coyote_timer.one_shot
	add_child(coyote_timer)
	coyote_timer.timeout.connect(on_coyote_timer_timeout)
	
	
func on_coyote_timer_timeout():
	coyote_jump_ready = false
	
	
	
	
	
