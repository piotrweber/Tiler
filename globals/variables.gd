extends Node

func _ready() -> void:
	Sigs.coin_collected.connect(func(value): Vars.coins = value)

var coins : int = 0:
	set(value):
		if value > 0:
			coins += value
			Sigs.coin_value_updated.emit()
