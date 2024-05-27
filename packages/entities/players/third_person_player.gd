extends CharacterBody3D

const CAMERA_CONTROLLER_ROTATION_SPEED := 3.0
const CAMERA_MOUSE_ROTATION_SPEED := 0.01
# A minimum angle lower than or equal to -90 breaks movement if the player is looking upward.
const CAMERA_X_ROT_MIN := deg_to_rad(-89.9)
const CAMERA_X_ROT_MAX := deg_to_rad(70)


@export var player_input : Node3D

@export var camera_base : Node3D
@export var camera_rot : Node3D
@export var camera_camera : Camera3D

const MOTION_INTERPOLATE_SPEED = 10
var motion = Vector2()

func _input(event):
	if event is InputEventScreenDrag:
		
		#var scale_factor: float = min(
		#	(float(get_viewport().size.x) / get_viewport().get_visible_rect().size.x),
		#	(float(get_viewport().size.y) / get_viewport().get_visible_rect().size.y)
		#	)
		rotate_camera(event.relative*CAMERA_MOUSE_ROTATION_SPEED)
				
	
	

func _process(delta):
	#motion = motion.lerp(player_input.motion, MOTION_INTERPOLATE_SPEED * delta)
	motion = player_input.motion
	print(motion)
	var camera_basis : Basis = get_camera_rotation_basis()
	var camera_z := camera_basis.z
	var camera_x := camera_basis.x

	camera_z.y = 0
	camera_z = camera_z.normalized()
	camera_x.y = 0
	camera_x = camera_x.normalized()
	
	var direction = Vector3(motion.x,0,motion.y).normalized()
	#direction = direction.rotated(Vector3.UP, camera_basis.get_euler().y).normalized()
	
	velocity = - direction * 5
	
	move_and_slide()
	
func rotate_camera(move):
	camera_base.rotate_y(-move.x)
	camera_base.orthonormalize()
	camera_rot.rotation.x=clamp(camera_rot.rotation.x+move.y,CAMERA_X_ROT_MIN,CAMERA_X_ROT_MAX)

	


func get_camera_base_quaternion() -> Quaternion:
	return camera_base.global_transform.basis.get_rotation_quaternion()


func get_camera_rotation_basis() -> Basis:
	return camera_rot.global_transform.basis
	
	
	
