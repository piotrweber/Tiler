extends Node

@export_range(1.0, 3.0, 0.05) var peak_scale: float = 1.5
@export_range(0.0, 1.0, 0.05) var scale_variance: float = 0.3
@export_range(0.05, 1.0, 0.05) var duration: float = 0.3

var sprite: Sprite2D

func _ready() -> void:
	sprite = owner.sprite
	owner.signals.colored.connect(on_colored)

func on_colored():
	var actual_peak := peak_scale + randf_range(-scale_variance, scale_variance)
	sprite.scale = Vector2.ONE
	var tween := create_tween()
	tween.tween_property(sprite, "scale", Vector2.ONE * actual_peak, duration * 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ONE, duration * 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
