extends State
class_name FallState

@export var idle_state : State = null
@export var jump_state : State = null
@export var wall_jump_state : State = null
@export var move_state : State = null

func enter() -> void:
	super()

func process_input(event : InputEvent) -> State:
	dasher.try_dash()
	var jump_pressed = Input.is_action_just_pressed("jump")
	if jump_pressed or mover.input_timer.time_left > 0:
		var move = Input.get_axis("move_left", "move_right")
		if mover.is_coyote_ready:
			return jump_state
		elif player.is_on_wall() and move != 0:
			return wall_jump_state
		elif jump_pressed and mover.can_double_jump:
			mover.can_double_jump = false
			return jump_state
	if jump_pressed:
		mover.input_timer.start()
	return null

func process_physics(delta : float) -> State:
	var move = Input.get_axis("move_left", "move_right")
	player.velocity.x = mover.move_x(player.velocity.x, move, delta)
	player.velocity.y += mover.get_gravity(move) * delta
	player.move_and_slide()

	if player.is_on_floor():
		if move != 0:
			return move_state
		return idle_state

	return null

func process_frame(delta : float) -> State:
	return null
