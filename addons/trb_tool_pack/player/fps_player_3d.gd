class_name FpsPlayer3D
extends CharacterBody3D

@export_category("CharacterSetup")
@export_subgroup("Movement", "mapkey_")
@export
var mapkey_forward = "forward"
@export
var mapkey_backward = "backward"
@export
var mapkey_left = "left"
@export
var mapkey_right = "right"
@export
var mapkey_jump = "jump"
@export
var mapkey_turn_left = "counterclock"
@export
var mapkey_turn_right = "clockwise"


@export_category("Character")
@export_range(0,50,0.25,"Speed in Units")
var walk_speed:float = 5.0
@export_range(0,50,0.25,"Speed in Units")
var sneak_speed:float = 3.0

@export_range(0,50,0.25,"Power in Units")
var jump_power:float = 4.5
@export var cam_setup:FPVCamSetup


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed(mapkey_jump) and is_on_floor():
		velocity.y = jump_power

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector(\
		mapkey_left, mapkey_right,\
		mapkey_forward, mapkey_backward)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * walk_speed
		velocity.z = direction.z * walk_speed
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed)
		velocity.z = move_toward(velocity.z, 0, walk_speed)

	move_and_slide()
