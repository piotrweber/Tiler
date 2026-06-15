extends Node
class_name PlatformTileSignals


signal colored
signal previewed
signal locked
var parent : PlatformTile


func _ready() -> void:
	
	owner.signals = self
	
