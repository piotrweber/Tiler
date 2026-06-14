extends State
class_name MoveState

# States to which transition
@export var idle_state : State = null
@export var jump_state : State = null

func enter() -> void:
	super()
	player.velocity.x = 200
	
func process_input(event : InputEvent) -> State:
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		return jump_state
	return null	

func process_physics(delta : float) -> State:
	player.velocity.y += gravity * delta
	
	var move = Input.get_axis('move_left','move_right') * 200
	player.velocity.x = move
	player.move_and_slide()
	
	if move == 0:
		return idle_state
			
	return null
	
	
	
	player.move_and_slide()
	return null
	
func process_frame(delta : float) -> State:
	return null
