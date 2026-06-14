extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var signals : CoinSignals
var value : int = 1

func _ready() -> void:
	animated_sprite_2d.play("default")
	signals.collected.connect(_on_collected)

func _on_collected():
	Sigs.coin_collected.emit(value)
	queue_free()
	
