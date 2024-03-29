class_name CrouchingPlayerState
extends PlayerMovementState

@export var SPEED : float = 3.5
@export var ACCCELERATION : float = 0.1
@export var DECELRATION : float = 0.25
@export_range(1, 6, 0.1) var CROUCH_SPEED : float = 4.0

@onready var CROUCH_SHAPECAST : ShapeCast3D = %ShapeCast3D

func enter() -> void:
	#ANIMATION.play("crouch", -1.0, CROUCH_SPEED)
	pass
	
func update(delta):
	
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCCELERATION, DECELRATION)
	PLAYER.update_velocity()
		
	#if Input.is_action_just_released("crouch"):
	#	uncrouch()
			
	if PLAYER.velocity.y < -3.0 and !PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")	
		
#func uncrouch():
#	if CROUCH_SHAPECAST.is_colliding() == false and Input.is_action_just_pressed("crouch") == false:
#		ANIMATION.play("crouch", -1.0,-CROUCH_SPEED * 1.5, true)
#		if ANIMATION.is_playing():
#			await ANIMATION.animation_finished
#		transition.emit("IdlePlayerState")
#	elif CROUCH_SHAPECAST.is_colliding() == true:
#		await get_tree().create_timer(0.1).timeout
#		uncrouch()
			
		
		
