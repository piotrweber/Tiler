extends Node

@export_range(1.0, 15.0, 0.5) var wobble_angle: float = 5.0
@export_range(0.0, 10.0, 0.5) var angle_variance: float = 2.0
@export_range(0.1, 2.0, 0.05) var period: float = 0.4

var _tween: Tween
var sprite: Sprite2D

func _ready() -> void:
	sprite = owner.sprite
	owner.signals.previewed.connect(_start_wobble)
	owner.signals.locked.connect(_stop_wobble)

func _start_wobble() -> void:
	if _tween != null and _tween.is_valid():
		return
	var angle := wobble_angle + randf_range(-angle_variance, angle_variance)
	sprite.rotation_degrees = randf_range(-angle, angle)
	_tween = create_tween().set_loops()
	_tween.tween_property(sprite, "rotation_degrees", angle, period * 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	_tween.tween_property(sprite, "rotation_degrees", -angle, period * 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func _stop_wobble() -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()
		_tween = null
	var snap := create_tween()
	snap.tween_property(owner.sprite, "rotation_degrees", 0.0, period * 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
