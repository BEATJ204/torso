class_name WalkingPlayerState
extends State

@export var animation : AnimationPlayer
@export var top_anim_speed : float = 2.2

func enter() -> void:
	animation.play("Walking",-1.0,1.0)
	Global.player._speed = Global.player.speed_default

func update(delta):
	if Global.player.velocity.length () == 0.0:
		transition.emit("IdlePlayerState")
		
func set_animation_speed(spd):
	var alpha = remap(spd, 0.0, Global.player.speed_default, 0.0, 1.0)
	animation.speed_scale = lerp (0.0, top_anim_speed, alpha)

func _input(event) -> void:
	if event.is_action_pressed("sprint") and Global.player.is_on_floor():
		transition.emit("SprintingPlayerState")
