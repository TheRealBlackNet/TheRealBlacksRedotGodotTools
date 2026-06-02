extends CharacterBody3D
class_name FreeCam

var input_mouse:Vector2
var rotation_target:Vector3
var mouse_sensitivity:int = 700
var in_menue:bool = false

@export
var speed:float = 30.0

func _ready() -> void:
	MouseCapture.grab_mouse()

func _physics_process(delta):
	movement(delta)
	look_around(delta)

func _input(event):
	# one esc releases the mouse (good for debugging)
	# a second esc return to the main menu:
	if Input.is_key_pressed(KEY_ESCAPE):
		MouseCapture.free_mouse()
	elif event is InputEventMouseButton:
		var e:InputEventMouseButton = event
		if e.button_index > 0:
			MouseCapture.grab_mouse()
	
	if Input.is_key_pressed(KEY_F1):
		%CollisionShape3D.disabled = true
	else:
		%CollisionShape3D.disabled = false
	
	save_mouse_movement(event)


func look_around(delta:float):
	if MouseCapture.is_mouse_free():
		return
	var camera:Camera3D = %Camera3D
	camera.rotation.z = lerp_angle(camera.rotation.z, -input_mouse.x * 25 * delta, delta * 5)	
	camera.rotation.x = lerp_angle(camera.rotation.x, rotation_target.x, delta * 25)
	rotation.y = lerp_angle(rotation.y, rotation_target.y, delta * 25)


func movement(delta:float):
	var s = speed
	
	if Input.is_key_pressed(KEY_SHIFT):
		s = 2 * s
	
	if Input.is_key_pressed(KEY_SPACE):
		velocity.y = s
	elif Input.is_key_pressed(KEY_C):
		velocity.y = -s
	else:
		velocity.y = move_toward(velocity.y, 0, s)

	var input_dir = Input.get_vector(\
		"left", "right", "forward", "backward")
	var direction = (transform.basis\
			* Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * s
		velocity.z = direction.z * s
	else:
		velocity.x = move_toward(velocity.x, 0, s)
		velocity.z = move_toward(velocity.z, 0, s)

	if position.y <= -400.0:
		position = Vector3(0,10,0)
	
	move_and_slide()


func save_mouse_movement(event):
	if event is InputEventMouseMotion:
		input_mouse = event.relative / mouse_sensitivity
		rotation_target.y -= event.relative.x / mouse_sensitivity
		rotation_target.x -= event.relative.y / mouse_sensitivity
	# limit view always from down to up:
	rotation_target.x = clamp(\
		rotation_target.x,\
		deg_to_rad(-90),\
		deg_to_rad(90))

func getCam() -> Camera3D:
	return %Camera3D
