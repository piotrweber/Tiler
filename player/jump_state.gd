extends State
class_name JumpState

# States to which transition
@export var state_idle : State = null
@export var move_state : State = null
@export var fall_state : State = null

func enter() -> void:
	super()
	player.velocity.y = -500


func process_physics(delta : float) -> State:
	# Process Y first
	player.velocity.y += gravity * delta
	
	if player.velocity.y >= 0:
		return fall_state
	
	# Process X
	var move = Input.get_axis('move_left','move_right') * 200
	player.velocity.x = move
	player.move_and_slide()
	
	if player.is_on_floor():
		if move != 0:
			return move_state
		return state_idle

	return null
	
func process_frame(delta : float) -> State:
	return null
