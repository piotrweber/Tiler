extends State
class_name IdleState

# States to which transition
@export var move_state : State
@export var jump_state : State
@export var fall_state : State

func enter() -> void:
	super()
	player.velocity.x = 0
	
func process_input(event : InputEvent) -> State:
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		return jump_state
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right") and player.is_on_floor():
		return move_state
	return null

func process_physics(delta : float) -> State:
	player.velocity.y += gravity * delta
	player.move_and_slide()
	
	if !player.is_on_floor():
		return fall_state
	return null
	
func process_frame(delta : float) -> State:
	return null
