@tool
extends ConvexPolygonShape2D
class_name RegularShape2D

@export_group("Regular-Polygon")
@export var radius:float = 50.0:
	set(val):
		radius = max(val, 0.001)
		_redoPoints()
@export var pointCount:int = 8:
	set(val):
		pointCount = max(val, 3)
		_redoPoints()
@export var rotationInDegree:float = 0.0:
	set(val):
		rotationInDegree = val
		_redoPoints()

func _ready() -> void:
	_redoPoints()

func _init():
	_redoPoints()

func _redoPoints():
	if pointCount <= 3:
		return
	points.clear()
	
	for i in range(pointCount):
		var dt := (TAU / float(pointCount)) * i
		var t := deg_to_rad(rotationInDegree)
		var x := sin(dt) * radius
		var y := cos(dt) * radius

		points.append(Vector2(x, y))
		print("xyy: " + str(x) + "-" + str(y))
	
	self.emit_changed()
	
