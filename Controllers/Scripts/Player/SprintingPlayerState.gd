class_name SprintingPlayerState
extends PlayerMovementState

@export var SPEED : float = 6.0
@export var ACCCELERATION : float = 0.2
@export var DECELRATION : float = 0.25
@export var TOP_ANIM_SPEED : float = 2.2

func enter() -> void:
#	if ANIMATION.is_playing() and ANIMATION.current_animation == "JumpEnd":
#		await ANIMATION.animation_finished
#		ANIMATION.play("Sprinting",-1.0,1.0)
#	else:
#		ANIMATION.play("Sprinting",-1.0,1.0)
	pass	
#func exit() -> void:
#	ANIMATION.speed_scale = 1.0
	
func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCCELERATION, DECELRATION)
	PLAYER.update_velocity()
	
	set_animation_speed(PLAYER.velocity.length())
	
	if Input.is_action_just_released("sprint"):
		transition.emit("WalkingPlayerState")
		
	if Input.is_action_pressed("sprint") and Input.is_action_just_pressed("jump"):
		transition.emit("SprintJumpPlayerState")
	elif Input.is_action_just_pressed("jump") and PLAYER.is_on_floor():
		transition.emit("JumpingPlayerState")
		
	if PLAYER.velocity.y < -3.0 and !PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")

func set_animation_speed(spd):
	var alpha = remap(spd, 0.0, SPEED, 0.0, 1.0)
	#ANIMATION.speed_scale = lerp (0.0, TOP_ANIM_SPEED, alpha)


