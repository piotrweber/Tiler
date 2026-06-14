extends Node
class_name StateMachine
# https://www.youtube.com/watch?v=oqFbZoA2lnU&t=311s

## Manges the state of the parent object delegating to the active state
## and managing transitions between states

@export var initial_state : State
@export var print_state : bool
var current_state : State
var previous_state : State
var player : Player

func _enter_tree() -> void:
	player = get_parent()
	owner.state_machine = self
	
# Initialise the state machine by giving each child state a reference to 
# the parent object it belongs to enter the default start_state
func init(
			p_player : Player,
			p_mover : Mover,
			p_sprite : Sprite2D,
			p_dasher : Dasher
			) -> void:

	for child : State in get_children():
		child.player = p_player
		child.sprite = p_sprite
		child.mover = p_mover
		child.dasher = p_dasher
		
	if initial_state:
		change_state(initial_state)
	else:
		printerr("Assign the initial state in the inspector")
		
func change_state(new_state : State) -> void:
	# call any exit logic on the current state 
	# before changing to a new state
	if current_state:
		current_state.exit()
	
	# temp remember the previous state
	var prev_s = current_state
	# switch to to the new one
	current_state = new_state
	# save the previous on the current sate
	current_state.previous_state = prev_s
	current_state.enter()
	if print_state:
		print(current_state)

# Pass-through functions for the parent to call,
# handling state changes as needed
func process_physics(delta : float)-> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event : InputEvent)-> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta : float)-> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
