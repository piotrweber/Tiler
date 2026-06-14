extends Node
class_name CoinSignals

signal collected

func _ready() -> void:
	owner.signals = self

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		collected.emit()
