class_name IdlePlayerState
extends PlayerMovementState

@export var SPEED : float = 5.0
@export var ACCCELERATION : float = 0.1
@export var DECELRATION : float = 0.25

func enter() -> void:
	if ANIMATION.is_playing() and ANIMATION.current_animation == "JumpEnd":
		await ANIMATION.animation_finished
		ANIMATION.pause()
	else:
		ANIMATION.pause()

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCCELERATION, DECELRATION)
	PLAYER.update_velocity()
	
	if Input.is_action_just_pressed("crouch"):
		transition.emit("CrouchingPlayerState")
	
	if PLAYER.velocity.length() > 0.0 and PLAYER.is_on_floor():
		transition.emit("WalkingPlayerState")
	
	if Input.is_action_just_pressed("jump") and PLAYER.is_on_floor():
		transition.emit("JumpingPlayerState")
	
	if PLAYER.velocity.y <0:
		transition.emit("FallingPlayerState")
