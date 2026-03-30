@tool
extends CollisionPolygon2D
class_name RegularCollisionPolygon2D

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
	if pointCount < 3:
		return
	polygon.clear()
	var newPoints:PackedVector2Array
	var rot := deg_to_rad(rotationInDegree)
	
	for i in range(pointCount):
		var dt := (TAU / float(pointCount)) * i + rot
		var x := sin(dt) * radius
		var y := cos(dt) * radius

		newPoints.append(Vector2(x, y))
	
	self.set_polygon(newPoints)
