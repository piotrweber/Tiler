extends BaseTile
class_name TrapTile

@export var randomize_position := false
@export var trap_delay := 2.0

@export var bw_sprite: AnimatedSprite2D
@export var colored_sprite: Sprite2D

var _trap_step_id := 0

func on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	if body.velocity.y < 0:
		return
	stepped_on.emit(self)
	_trap_step_id += 1
	var sid := _trap_step_id
	get_tree().create_timer(trap_delay).timeout.connect(func():
		if _trap_step_id == sid:
			trap_triggered.emit(self)
	)

func on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		stepped_off.emit(self)
		_trap_step_id += 1

func conceal() -> void:
	state = TileState.HIDDEN
	collision_shape_2d.set_deferred("disabled", true)
	bw_sprite.visible = false
	colored_sprite.visible = false

func preview() -> void:
	state = TileState.VISIBLE
	collision_shape_2d.set_deferred("disabled", false)
	bw_sprite.visible = true
	bw_sprite.play("attack")
	if signals != null:
		signals.previewed.emit()

func lock() -> void:
	state = TileState.LOCKED
	collision_shape_2d.set_deferred("disabled", false)
	bw_sprite.play("death")
	if signals != null:
		signals.locked.emit()

func restore_lock() -> void:
	state = TileState.LOCKED
	collision_shape_2d.set_deferred("disabled", false)
	bw_sprite.visible = true
	bw_sprite.play("death")

func colorize(_tex: Texture2D) -> void:
	is_colored = true
	bw_sprite.visible = false
	colored_sprite.visible = true
	if signals != null:
		signals.colored.emit()

func restore_color(_tex: Texture2D) -> void:
	is_colored = true
	bw_sprite.visible = false
	colored_sprite.visible = true

func update_sprite() -> void:
	pass
