@tool
extends CollisionPolygon2D
class_name CogCollisionPolygon2D

@export var tooth_count: int = 12:
	set(value):
		tooth_count = max(3, value)
		_redoPoints()

@export var flank_angle_deg: float = 12.0:
	set(value):
		flank_angle_deg = value
		_redoPoints()

@export var root_radius: float = 40.0:
	set(value):
		root_radius = max(1.0, value)
		_redoPoints()

@export var tip_radius: float = 60.0:
	set(value):
		tip_radius = max(root_radius + 1.0, value)
		_redoPoints()


func _ready():
	if Engine.is_editor_hint():
		_redoPoints()


func _redoPoints():
	#if not Engine.is_editor_hint():
	#	return

	var pts: Array[Vector2] = []
	pts.resize(tooth_count * 4)

	var angle_step = TAU / tooth_count
	var flank_angle = deg_to_rad(flank_angle_deg)

	for i in range(tooth_count):
		var base_angle = i * angle_step

		var a1 = base_angle - flank_angle
		var a2 = base_angle - flank_angle * 0.3
		var a3 = base_angle + flank_angle * 0.3
		var a4 = base_angle + flank_angle

		var p1 = Vector2(root_radius, 0).rotated(a1)
		var p2 = Vector2(tip_radius, 0).rotated(a2)
		var p3 = Vector2(tip_radius, 0).rotated(a3)
		var p4 = Vector2(root_radius, 0).rotated(a4)

		var idx = i * 4
		pts[idx] = p1
		pts[idx + 1] = p2
		pts[idx + 2] = p3
		pts[idx + 3] = p4

	polygon = pts
