extends Node
class_name State

## Base class all states inherit from

# Have a consistent value for every physics object
#var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")
# Hold a reference to nodes used by states
var sprite : Sprite2D = null
var player : Player = null
var mover : Mover = null
# Save the state we came from
var previous_state : State = null

# Functions implements by children classes

# Called once upon entering the current state
func enter() -> void:
	pass

# Called once before exiting the current state
func exit()-> void:
	pass

func process_input(event : InputEvent) -> State:
	return null

# Called every frame
func process_physics(delta : float) -> State:
	return null

# Called every frame	
func process_frame(delta : float) -> State:
	return null
