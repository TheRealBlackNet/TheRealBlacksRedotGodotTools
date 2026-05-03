class_name MouseCapture
extends Node

var grabbed:bool = false
var just:bool = false

func _ready() -> void:
	grab_mouse()

func grab_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	grabbed = true

func free_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	grabbed = false

func end_game():
	get_tree().free()



func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		return
	if event is InputEventMouseButton and !grabbed and event.is_pressed():
		grab_mouse()
	elif event is InputEventKey\
			and event.keycode == Key.KEY_ESCAPE:
		if grabbed:
			free_mouse()
		else:
			end_game()
