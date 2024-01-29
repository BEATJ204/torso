class_name SprintJumpPlayerState
extends PlayerMovementState

@export var SPEED : float = 6.0
@export var ACCCELERATION : float = 0.2
@export var DECELRATION : float = 0.25
@export var JUMP_VELOCITY : float = 4.5
@export var TOP_ANIM_SPEED : float = 2.2
@export_range(0.5, 1.0, 0.01) var JUMP_SPEED_MULTIPLIER : float = 1.1

func enter() -> void:
	ANIMATION.play("Sprinting",0.5,1.0)
	PLAYER.velocity.y += JUMP_VELOCITY
	
func exit() -> void:
	ANIMATION.speed_scale = 1.0
	
func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED * JUMP_SPEED_MULTIPLIER, ACCCELERATION, DECELRATION)
	PLAYER.update_velocity()
	
	if PLAYER.is_on_floor():
		transition.emit("IdlePlayerState")
		
	if Input.is_action_just_pressed("crouch"):
		transition.emit("CrouchingPlayerState")

func set_animation_speed(spd):
	var alpha = remap(spd, 0.0, SPEED, 0.0, 1.0)
	ANIMATION.speed_scale = lerp (0.0, TOP_ANIM_SPEED, alpha)
