extends State
class_name FallState

# States to which transition
@export var state_idle : State = null

func enter() -> void:
	super()


func process_physics(delta : float) -> State:
	player.velocity.y += gravity * delta
		
	var move = Input.get_axis('move_left','move_right') * 150
	player.velocity.x = move
	player.move_and_slide()
	
	if player.is_on_floor():
		return state_idle
			
	return null
	
func process_frame(delta : float) -> State:
	return null
