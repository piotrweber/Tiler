extends State
class_name FallState

# States to which transition
@export var state_idle : State = null
@export var jump_state : State = null

func enter() -> void:
	super()


func process_input(event : InputEvent) -> State:
	var jump_attempted = Input.is_action_just_pressed("jump")
	return mover.jump_buffer(jump_attempted, jump_state)

	return null

func process_physics(delta : float) -> State:
	player.velocity.y += mover.gravity * delta
		
	var move = Input.get_axis('move_left','move_right') * mover.move_air_velocity
	player.velocity.x = move
	player.move_and_slide()
	
	if player.is_on_floor():
		return state_idle
			
	return null
	
func process_frame(delta : float) -> State:
	return null
