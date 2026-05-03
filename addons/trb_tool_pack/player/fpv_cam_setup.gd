class_name FPVCamSetup
extends Node3D

@export_category("Camera Oprions")
@export var player:FpsPlayer3D:
	set(value):
		player = value
		if player != null:
			#player.
			print("connect crouch event")
			return

@export var rotating_cam:Camera3D
@export var current_cam_position:Node3D
@export var position_standing:Node3D
@export var position_crawl:Node3D
@export_range(0.25, 100.0, 0.25, "Factor")
var mouse_sensitivity:float = 10.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x / mouse_sensitivity
		rotating_cam.rotation_degrees.x -= event.relative.y / mouse_sensitivity
		rotating_cam.rotation_degrees.x = clamp(\
			rotating_cam.rotation_degrees.x, -90, 90)
	if event is InputEventKey and event.keycode == Key.KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
