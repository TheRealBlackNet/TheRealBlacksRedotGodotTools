@tool
extends ConvexPolygonShape2D
class_name RegularShape2D

@export_group("Regular-Polygon")
@export var radius:float = 50.0:
	set(val):
		radius = max(val, 0.001)
		_redoPoints()
@export var point_count:int = 8:
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
	points.clear()
	
	var new_points:PackedVector2Array
	var rot := deg_to_rad(rotation_deg)
	
	for i in range(point_count):
		var dt := (TAU / float(point_count)) * i + rot
		var x := sin(dt) * radius
		var y := cos(dt) * radius

		new_points.append(Vector2(x, y))
	
	self.set_point_cloud(new_points)
	self.emit_changed()
	
