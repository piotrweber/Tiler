extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var colored_frames: SpriteFrames

var signals : CoinSignals
var value : int = 1

func _ready() -> void:
	animated_sprite_2d.play("default")
	signals.collected.connect(_on_collected)

func colorize() -> void:
	if colored_frames != null:
		animated_sprite_2d.sprite_frames = colored_frames
		animated_sprite_2d.play("default")

func _on_collected():
	Sigs.coin_collected.emit(value)
	queue_free()
	
