class_name SprintingPlayerState
extends State

@export var animation : AnimationPlayer
@export var top_anim_speed : float = 2.2

func enter() -> void:
	animation.play("Sprinting",0.5,1.0)
	Global.player._speed = Global.player.speed_sprint
	
func update(delta):
	set_animation_speed(Global.player.velocity.length())

func set_animation_speed(spd):
	var alpha = remap(spd, 0.0, Global.player.speed_sprint, 0.0, 1.0)
	animation.speed_scale = lerp (0.0, top_anim_speed, alpha)

func _input(event) -> void:
	if event.is_action_released("sprint"):
		transition.emit("WalkingPlayerState")
