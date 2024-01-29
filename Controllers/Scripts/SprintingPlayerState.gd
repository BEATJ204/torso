class_name SprintingPlayerState
extends PlayerMovementState

@export var SPEED : float = 7.0
@export var ACCCELERATION : float = 0.2
@export var DECELRATION : float = 0.25
@export var TOP_ANIM_SPEED : float = 2.2

func enter() -> void:
	ANIMATION.play("Sprinting",0.5,1.0)
	
func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCCELERATION, DECELRATION)
	PLAYER.update_velocity()
	
	set_animation_speed(PLAYER.velocity.length())
	
	if Input.is_action_just_released("sprint"):
		transition.emit("WalkingPlayerState")

func set_animation_speed(spd):
	var alpha = remap(spd, 0.0, SPEED, 0.0, 1.0)
	ANIMATION.speed_scale = lerp (0.0, TOP_ANIM_SPEED, alpha)


