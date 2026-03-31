@tool
extends Curve2D
class_name SinusCurve2D

@export_group("Sinus")
@export var frequency:float = 1.0:
	set(val):
		frequency = max(val, 0.001)
		_redoPoints()
@export var point_line:int = 20:
	set(val):
		point_line = max(val, 2)
		_redoPoints()
@export var box_size:Vector2 = Vector2(300.0, 75.0):
	set(val):
		box_size = val
		_redoPoints()
@export var delta_time:float = 0.0:
	set(val):
		delta_time = val
		_redoPoints()

func _ready() -> void:
	_redoPoints()

func _init():
	_redoPoints()

func _redoPoints():
	if point_line <= 0:
		return

	var dx := box_size.x / float(point_line - 1)

	clear_points()
	for i in range(point_line):
		var x := i * dx
		var t := float(i) / float(point_line - 1)
		var y := sin(\
			t * frequency * TAU + delta_time * TAU)\
			* box_size.y / 2.0

		add_point(Vector2(x, y))
	
	self.emit_changed()
	
