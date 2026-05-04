class_name MouseCapture
extends Node

var just:bool = false

func _ready() -> void:
	grab_mouse()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		return
	if event is InputEventMouseButton\
			and is_mouse_free()\
			and event.is_pressed():
		just = false
		grab_mouse()
	elif event is InputEventKey\
			and event.keycode == Key.KEY_ESCAPE\
			and !just:
		if is_mouse_grabbed():
			free_mouse()
		else:
			if !just and is_mouse_free():
				end_game()
		just = true
	elif event is InputEventKey:
		just = false


static func is_mouse_grabbed() -> bool:
	return Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED

static func is_mouse_trapped() -> bool:
	return Input.get_mouse_mode() == Input.MOUSE_MODE_CONFINED

static func is_mouse_free() -> bool:
	return Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE

static func grab_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

static func trap_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

static func free_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func end_game() -> void:
	get_tree().free()
