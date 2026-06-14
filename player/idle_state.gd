extends State
class_name IdleState

@export var move_state : State
@export var jump_state : State
@export var fall_state : State

func enter() -> void:
	super()
	mover.can_double_jump = false
	mover.double_jump_timer.stop()

func process_input(event : InputEvent) -> State:
	dasher.try_dash()
	if Input.is_action_just_pressed("jump") or mover.input_timer.time_left > 0:
		return jump_state
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		return move_state
	return null

func process_physics(delta : float) -> State:
	player.velocity.x = mover.move_x(player.velocity.x, 0.0, delta)
	player.velocity.y += mover.gravity * delta
	player.move_and_slide()
	dasher.apply_snap(player)

	if not player.is_on_floor():
		# Player walked off a ledge — arm coyote so they can still jump briefly
		mover.is_coyote_ready = true
		if mover.coyote_timer.is_stopped():
			mover.coyote_timer.start()
		return fall_state

	return null

func process_frame(delta : float) -> State:
	return null
