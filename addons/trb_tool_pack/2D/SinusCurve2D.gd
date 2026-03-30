@tool
extends Curve2D
class_name SinusCurve2D

@export_group("Sinus")
@export var frequency:float = 1.0:
	set(val):
		frequency = max(val, 0.001)
		_redoPoints()
@export var points:int = 20:
	set(val):
		points = max(val, 2)
		_redoPoints()
@export var boxSize:Vector2 = Vector2(300.0, 75.0):
	set(val):
		boxSize = val
		_redoPoints()
@export var deltaTime:float = 0.0:
	set(val):
		deltaTime = val
		_redoPoints()

func _ready() -> void:
	_redoPoints()

func _init():
	_redoPoints()

func _redoPoints():
	if points <= 0:
		return

	var dx := boxSize.x / float(points - 1)

	clear_points()
	for i in range(points):
		var x := i * dx
		var t := float(i) / float(points - 1)
		var y := sin(\
			t * frequency * TAU + deltaTime * TAU)\
			* boxSize.y / 2.0

		add_point(Vector2(x, y))
	
