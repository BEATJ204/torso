extends Camera3D

@onready var fps_rig = $fps_rig
@onready var animation_player = $"fps_rig/USP-S/AnimationPlayer"
@onready var gunshot_sound = $"fps_rig/USP-S/GunshotSound"  # Adjust the path to your AudioStreamPlayer node
@onready var marker_3d = %Marker3D

var has_shot = false  # Variable to track whether the shot has been fired

# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fps_rig.position.x = lerp(fps_rig.position.x, 0.0, delta * 5)
	fps_rig.position.y = lerp(fps_rig.position.y, 0.0, delta * 5)

	if Input.is_action_pressed("shoot") and not has_shot:
		animation_player.play("shoot")
		has_shot = true

	if Input.is_action_just_released("shoot"):
		has_shot = false  # Reset has_shot when the "shoot" key is released

func sway(sway_amount):
	fps_rig.position.x -= sway_amount.x * 0.00005
	fps_rig.position.y += sway_amount.y * 0.00005

func _play_gunshot_audio():
	gunshot_sound.pitch_scale = randf_range(1.0, 1.1)  # Adjust the range as needed
	gunshot_sound.play()
	
func shoot():
	$"fps_rig/USP-S".Shoot()
pass
