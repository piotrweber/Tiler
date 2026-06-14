extends State
class_name WallJumpState

@export var fall_state : State = null
@export var idle_state : State = null

func enter() -> void:
	super()
	var move = Input.get_axis("move_left", "move_right")
	player.velocity.y = mover.wall_jump_velocity
	if move != 0:
		player.velocity.x = mover.wall_jump_pushback * -sign(move)

func process_input(event : InputEvent) -> State:
	dasher.try_dash()
	return null

func process_physics(delta : float) -> State:
	var horizontal_input = Input.get_axis("move_left", "move_right")
	player.velocity.x = mover.move_x(player.velocity.x, horizontal_input, delta)
	player.velocity.y += mover.get_gravity(horizontal_input) * delta
	player.move_and_slide()
	dasher.clamp_to_target()

	if player.is_on_floor():
		return idle_state
	if player.velocity.y >= 0:
		return fall_state

	return null

func process_frame(delta : float) -> State:
	return null
