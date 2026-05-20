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


func _input(event: InputEvent) -> void:
	if MouseCapture.is_mouse_free() || MouseCapture.is_mouse_trapped():
		return # tab out or in menue
	if event is InputEventMouseMotion:
		player.rotation_degrees.y -= event.relative.x / mouse_sensitivity
		rotating_cam.rotation_degrees.x -= event.relative.y / mouse_sensitivity
		rotating_cam.rotation_degrees.x = clamp(\
			rotating_cam.rotation_degrees.x, -90, 90)

		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
