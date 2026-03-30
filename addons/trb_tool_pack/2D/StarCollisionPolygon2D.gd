@tool
extends CollisionPolygon2D
class_name StarCollisionPolygon2D

@export_group("Star-Polygon")
@export var radiusInner:float = 40.0:
	set(val):
		radiusInner = max(val, 0.001)
		_redoPoints()
@export var radiusOuter:float = 60.0:
	set(val):
		radiusOuter = max(val, 0.001)
		_redoPoints()
@export var pointCount:int = 4:
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

	for i in range(0,pointCount*2,2):
		var dt1 := (TAU / float(pointCount)) * i / 2.0 + rot
		var x1 := sin(dt1) * radiusOuter
		var y1 := cos(dt1) * radiusOuter
		newPoints.append(Vector2(x1, y1))

		var dt2 := (TAU / float(pointCount)) * i / 2.0 + rot\
			+ (TAU / float(pointCount) / 2.0)
		var x2 := sin(dt2) * radiusInner
		var y2 := cos(dt2) * radiusInner
		newPoints.append(Vector2(x2, y2))

	self.set_polygon(newPoints)
