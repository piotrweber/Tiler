extends Sprite2D
class_name DashSprite

## Attached to a sprite and generates the effect

var vfx_duration : float

func _ready():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0,vfx_duration)
	tween.tween_callback(done)

# make the ghost look like the player when dashing
func init(player_sprite : Sprite2D, player_position : Vector2, ghost_duration : float):
	texture = player_sprite.texture
	vframes = player_sprite.vframes
	hframes = player_sprite.hframes
	frame = player_sprite.frame
	flip_h = player_sprite.flip_h
	global_position = player_position
	vfx_duration = ghost_duration
	

func done():
	queue_free()
