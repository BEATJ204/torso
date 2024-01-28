extends CharacterBody3D

@export var JUMP_VELOCITY = 4.5
@export var speed_default : float = 5.0
@export var speed_crouch : float = 3.5 
@export var Toggle_crouch : bool = true
@export var animationplayer : AnimationPlayer
@export var crouch_shapecast : Node3D
@export_range(0, 10, 0.1) var mouse_sens : float = 3.0
@export_range(5, 10, 0.1) var crouch_speed : float = 7.0

var minPitch = deg_to_rad(-90)
var maxPitch = deg_to_rad(90)
var _speed : float  

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var _is_crouching : bool = false


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_speed = speed_default

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
	
	if event.is_action_pressed("crouch") and Toggle_crouch == true:
		toggle_crouch()
	if event.is_action_pressed("crouch") and _is_crouching == false and Toggle_crouch == false: #Hold to crouch
			crouching(true)
	if event.is_action_released("crouch") and Toggle_crouch == false: # Release to uncrouch
		if crouch_shapecast.is_colliding() == false:
			crouching(false )
		elif crouch_shapecast.is_colliding() == true:
			uncrouch_check()
	
	if event is InputEventMouseMotion:
		rotation.y	-= event.relative.x / 1000 * mouse_sens
		$Camera3D.rotation.x -= event.relative.y / 1000 * mouse_sens
		
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, minPitch, maxPitch)
		
		rotation.y = fmod(rotation.y, PI * 2)
		
func toggle_crouch():
	if _is_crouching == true and crouch_shapecast.is_colliding() == false:
		crouching(false)
	elif _is_crouching == false:
		crouching(true)		
		
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if _is_crouching and not crouch_shapecast.is_colliding():
			# Uncrouch only if crouching and not colliding with something
			crouching(false)
			_is_crouching = false
		elif is_on_floor() and not _is_crouching:
			# Regular jump when not crouching
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "foward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * _speed
		velocity.z = direction.z * _speed
	else:
		velocity.x = move_toward(velocity.x, 0, _speed)
		velocity.z = move_toward(velocity.z, 0, _speed)

	move_and_slide()
			
func uncrouch_check():
	if crouch_shapecast.is_colliding() == false:
		crouching(false)
	if crouch_shapecast.is_colliding() == true:
		await get_tree().create_timer(0.1).timeout
		uncrouch_check()

func crouching(state : bool):
		match state:
			true:
				animationplayer.play("crouch", -1, crouch_speed)
				set_movement_speed("crouching")
			false:
				animationplayer.play("crouch", -1, -crouch_speed, true)
				set_movement_speed("default")

func _on_animation_player_animation_started(anim_name):
	if anim_name == "crouch":
		_is_crouching = !_is_crouching
		
func set_movement_speed(state : String):
	match state:
		"default":
			_speed = speed_default
		"crouching":
			_speed = speed_crouch
