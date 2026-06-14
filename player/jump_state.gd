extends State
class_name JumpState

@export var state_idle : State = null
@export var move_state : State = null
@export var fall_state : State = null
@export var wall_jump_state : State = null
@export var jump_state : State = null

func enter() -> void:
	super()
	mover.is_coyote_ready = false
	mover.coyote_timer.stop()
	player.velocity.y = -mover.jump_velocity
	mover.can_double_jump = true
	mover.double_jump_timer.start(mover.double_jump_window)

func process_input(event : InputEvent) -> State:
	dasher.try_dash()
	if Input.is_action_just_pressed("jump"):
		if player.is_on_wall():
			var move = Input.get_axis("move_left", "move_right")
			if move != 0:
				return wall_jump_state
		if mover.can_double_jump:
			mover.can_double_jump = false
			return jump_state
	return null

func process_physics(delta : float) -> State:
	var horizontal_input = Input.get_axis("move_left", "move_right")
	player.velocity.x = mover.move_x(player.velocity.x, horizontal_input, delta)
	player.velocity.y += mover.get_gravity(horizontal_input) * delta
	player.move_and_slide()
	dasher.clamp_to_target()

	if player.velocity.y >= 0:
		return fall_state

	if player.is_on_floor():
		if horizontal_input != 0.0:
			return move_state
		return state_idle

	return null

func process_frame(delta : float) -> State:
	return null
