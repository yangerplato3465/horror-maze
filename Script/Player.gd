extends KinematicBody

const GRAVITY = -24.8
var vel = Vector3()
const MAX_SPEED = 7
const JUMP_SPEED = 18
const ACCEL = 4.5

var dir = Vector3()

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

var camera
var rotation_helper

var MOUSE_SENSITIVITY = 0.05
onready var collider = $Area
onready var footsteps = $FootStep
onready var growl = $Growl
onready var fader = $Fader
var isWalking = false
var shake_amount = 0;
var isDying = false
var monster = null
signal orb_collected

func _ready():
	randomize()
	camera = $CameraPivot/Camera
	rotation_helper = $CameraPivot

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func set_monster(monster):
	self.monster = monster

func _physics_process(delta):
	if isDying:
		shake_amount += 0.02 * delta
		camera.h_offset = rand_range(-1, 1) * shake_amount
		camera.v_offset = rand_range(-1, 1) * shake_amount
		self.look_at(monster.global_transform.origin, Vector3.UP)
		return

	process_input(delta)
	process_movement(delta)

func process_input(delta):

	# ----------------------------------
	# Walking
	dir = Vector3()
	var cam_xform = camera.get_global_transform()

	var input_movement_vector = Vector2()

	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("movement_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("movement_right"):
		input_movement_vector.x += 1
	if Input.is_action_just_pressed("toggle_flashlight"):
		$CameraPivot/SpotLight.visible = !$CameraPivot/SpotLight.visible

	input_movement_vector = input_movement_vector.normalized()
	
	if input_movement_vector.x != 0 || input_movement_vector.y:
		isWalking = true
	else:
		isWalking = false
	
	if isWalking && !footsteps.playing:
		footsteps.play()
	if !isWalking && footsteps.playing:
		footsteps.stop()

	# Basis vectors are already normalized.
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
	# ----------------------------------

	# ----------------------------------
	# Jumping
#    if is_on_floor():
#        if Input.is_action_just_pressed("movement_jump"):
#            vel.y = JUMP_SPEED
	# ----------------------------------

	# ----------------------------------
	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# ----------------------------------

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

#	vel.y += delta * GRAVITY

	var hvel = vel
	hvel.y = 0

	var target = dir
	target *= MAX_SPEED

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot

func die():
	isDying = true
	fader.set_playback_speed(0.15)
	growl.play()
	fader.fade_in()

func _on_Area_area_entered(area):
	if area.is_in_group("Orbs"):
		area.queue_free()
		emit_signal("orb_collected")


func _on_Growl_finished():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
