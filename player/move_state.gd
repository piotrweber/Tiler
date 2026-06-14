extends State
class_name MoveState

@export var idle_state : State = null
@export var jump_state : State = null
@export var fall_state : State = null

func enter() -> void:
	super()
	mover.can_double_jump = false
	mover.double_jump_timer.stop()

func process_input(event : InputEvent) -> State:
	dasher.try_dash()
	if Input.is_action_just_pressed("jump") or mover.input_timer.time_left > 0:
		return jump_state
	return null

func process_physics(delta : float) -> State:
	var horizontal_input = Input.get_axis("move_left", "move_right")
	player.velocity.x = mover.move_x(player.velocity.x, horizontal_input, delta)
	player.velocity.y += mover.gravity * delta
	player.move_and_slide()
	dasher.apply_snap(player)

	if not player.is_on_floor():
		mover.is_coyote_ready = true
		if mover.coyote_timer.is_stopped():
			mover.coyote_timer.start()
		return fall_state

	if horizontal_input == 0.0:
		return idle_state

	return null

func process_frame(delta : float) -> State:
	return null
