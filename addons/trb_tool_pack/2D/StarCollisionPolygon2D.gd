@tool
extends CollisionPolygon2D
class_name StarCollisionPolygon2D

@export_group("Star-Polygon")
@export var radius_inner:float = 40.0:
	set(val):
		radius_inner = max(val, 0.001)
		_redoPoints()
@export var radius_outer:float = 60.0:
	set(val):
		radius_outer = max(val, 0.001)
		_redoPoints()
@export var point_count:int = 4:
	set(val):
		point_count = max(val, 3)
		_redoPoints()
@export var rotation_deg:float = 0.0:
	set(val):
		rotation_deg = val
		_redoPoints()

func _ready() -> void:
	_redoPoints()

func _init():
	_redoPoints()

func _redoPoints():
	if point_count < 3:
		return
	polygon.clear()
	var new_points:PackedVector2Array
	var rot := deg_to_rad(rotation_deg)

	for i in range(0,point_count*2,2):
		var dt1 := (TAU / float(point_count)) * i / 2.0 + rot
		var x1 := sin(dt1) * radius_outer
		var y1 := cos(dt1) * radius_outer
		new_points.append(Vector2(x1, y1))

		var dt2 := (TAU / float(point_count)) * i / 2.0 + rot\
			+ (TAU / float(point_count) / 2.0)
		var x2 := sin(dt2) * radius_inner
		var y2 := cos(dt2) * radius_inner
		new_points.append(Vector2(x2, y2))

	self.set_polygon(new_points)
