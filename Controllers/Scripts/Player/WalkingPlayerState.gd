class_name WalkingPlayerState
extends PlayerMovementState

@export var SPEED : float = 5.0
@export var ACCCELERATION : float = 0.1
@export var DECELRATION : float = 0.25
@export var TOP_ANIM_SPEED : float = 2.2

func enter() -> void:
	#if ANIMATION.is_playing() and ANIMATION.current_animation == "JumpEnd":
	#	await ANIMATION.animation_finished
	#	ANIMATION.play("Walking",-1.0,1.0)
	#else:
	#	ANIMATION.play("Walking",-1.0,1.0)
	pass
	
func exit() -> void:
	#ANIMATION.speed_scale = 1.0
	pass
		
func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCCELERATION, DECELRATION)
	PLAYER.update_velocity()
	
	set_animation_speed(PLAYER.velocity.length())
	if PLAYER.velocity.length () == 0.0:
		transition.emit("IdlePlayerState")
		
	if Input.is_action_pressed("sprint") and PLAYER.is_on_floor():
		transition.emit("SprintingPlayerState")
		
	if Input.is_action_pressed("crouch"):
		transition.emit("CrouchingPlayerState")
		
	if Input.is_action_just_pressed("jump") and PLAYER.is_on_floor():
		transition.emit("JumpingPlayerState")	
		
	if PLAYER.velocity.y <0:
		transition.emit("FallingPlayerState")
		
func set_animation_speed(spd):
	var alpha = remap(spd, 0.0, SPEED, 0.0, 1.0)
	# ANIMATION.speed_scale = lerp (0.0, TOP_ANIM_SPEED, alpha)

