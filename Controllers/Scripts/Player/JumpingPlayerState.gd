class_name JumpingPlayerState
extends PlayerMovementState

@export var SPEED : float = 6.0
@export var ACCCELERATION : float = 0.2
@export var DECELRATION : float = 0.25
@export var JUMP_VELOCITY : float = 4.5
@export_range(0.5, 1.0, 0.01) var INPUT_MULTIPLIER : float = 0.85

func enter() -> void:
	PLAYER.velocity.y += JUMP_VELOCITY
	ANIMATION.play("JumpStart")
	
func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED * INPUT_MULTIPLIER, ACCCELERATION, DECELRATION)
	PLAYER.update_velocity()
	
	if PLAYER.is_on_floor():
		ANIMATION.play("JumpEnd")
		transition.emit("IdlePlayerState")
	
	if Input.is_action_pressed("crouch"):
		transition.emit("CrouchingPlayerState")
		
