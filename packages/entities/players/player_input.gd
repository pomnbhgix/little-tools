extends Node3D

const CAMERA_CONTROLLER_ROTATION_SPEED := 3.0
const CAMERA_MOUSE_ROTATION_SPEED := 0.001
# A minimum angle lower than or equal to -90 breaks movement if the player is looking upward.
const CAMERA_X_ROT_MIN := deg_to_rad(-89.9)
const CAMERA_X_ROT_MAX := deg_to_rad(70)

# Release aiming if the mouse/gamepad button was held for longer than 0.4 seconds.
# This works well for trackpads and is more accessible by not making long presses a requirement.
# If the aiming button was held for less than 0.4 seconds, keep aiming until the aiming button is pressed again.
const AIM_HOLD_THRESHOLD = 0.4

# If `true`, the aim button was toggled checked by a short press (instead of being held down).
var toggled_aim := false

# The duration the aiming button was held for (in seconds).
var aiming_timer := 0.0

# Synchronized controls
@export var aiming := false
@export var shoot_target := Vector3()
@export var motion := Vector2()
@export var camera_move := Vector2()
@export var current_aim := false
@export var shooting := false
# This is handled via RPC for now
@export var jumping := false

# Camera and effects
@export var camera_animation : AnimationPlayer
@export var crosshair : TextureRect
@export var camera_base : Node3D
@export var camera_rot : Node3D
@export var camera_camera : Camera3D
@export var color_rect : ColorRect


func _process(_delta):
	handle_android_input()
	

func handle_android_input():
	
	motion = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	

	
func temp()	:
	motion = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_back") - Input.get_action_strength("move_forward"))
	camera_move = Vector2(
			Input.get_action_strength("view_right") - Input.get_action_strength("view_left"),
			Input.get_action_strength("view_up") - Input.get_action_strength("view_down"))
	
	current_aim = false

	# Keep aiming if the mouse wasn't held for long enough.
	if Input.is_action_just_released("aim") and aiming_timer <= AIM_HOLD_THRESHOLD:
		current_aim = true
		toggled_aim = true
	else:
		current_aim = toggled_aim or Input.is_action_pressed("aim")
		if Input.is_action_just_pressed("aim"):
			toggled_aim = false

	if Input.is_action_just_pressed("jump"):
		pass
		#jump.rpc()

	shooting = Input.is_action_pressed("shoot")
	
	

@rpc("call_local")
func jump():
	jumping = true
