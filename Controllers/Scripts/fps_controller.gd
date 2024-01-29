class_name Player
extends CharacterBody3D
 
@export var ANIMATIONPLAYER : AnimationPlayer
@export var CROUCH_SHAPECAST : Node3D
@export_range(0, 10, 0.1) var mouse_sens : float = 3.0
@export_range(5, 10, 0.1) var crouch_speed : float = 7.0

var minPitch = deg_to_rad(-90)
var maxPitch = deg_to_rad(90)
var speed : float  

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.player = self

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
	
	if event is InputEventMouseMotion:
		rotation.y	-= event.relative.x / 1000 * mouse_sens
		$Camera3D.rotation.x -= event.relative.y / 1000 * mouse_sens
		
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, minPitch, maxPitch)
		
		rotation.y = fmod(rotation.y, PI * 2)
		
func _physics_process(delta):
	Global.debug.add_property("Speed","%.2f" % velocity.length(), 1)
	
			
func update_gravity(delta) -> void:
	velocity.y -= gravity * delta
	pass
	
func update_input(speed: float, acceleration: float, deceleration: float) -> void:
	var input_dir = Input.get_vector("left", "right", "foward", "back")
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = lerp(velocity.x,direction.x * speed, acceleration)
		velocity.z = lerp(velocity.z,direction.z * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		velocity.z = move_toward(velocity.z, 0, deceleration)

func update_velocity() -> void:
	move_and_slide()
	

