@tool
extends ArrayMesh
class_name CogMesh

@export var tooth_count: int = 8:
	set(v):
		tooth_count = max(3, v)
		_rebuild()

@export var outer_radius: float = 5.0:
	set(v):
		outer_radius = max(0.01, v)
		_rebuild()

@export var tooth_depth: float = 1.5:
	set(v):
		tooth_depth = clamp(v, 0.01, outer_radius * 0.5)
		_rebuild()

@export var thickness: float = 2.0:
	set(v):
		thickness = max(0.01, v)
		_rebuild()

@export var tooth_cheek_percentage: float = 0.5:
	set(v):
		tooth_cheek_percentage = clamp(v, 0.0, 1.5 )
		_rebuild()

@export var shaft_radius: float = 1.0:
	set(v):
		shaft_radius = max(0.01, v)
		_rebuild()


var inner_radius: float
var element_rad: float
var delta_z: float

func _ready() -> void:
	if Engine.is_editor_hint():
		_rebuild()

func _rebuild() -> void:
	#if not Engine.is_editor_hint():
	#	return
	_calculate_derived()
	_generate_mesh()

func _calculate_derived() -> void:
	inner_radius = outer_radius - tooth_depth
	element_rad = TAU / float(2.0 * tooth_count)
	delta_z = thickness / 2.0

func _generate_mesh() -> void:
	clear_surfaces()

	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	for i in tooth_count:
		_add_tooth(st, i)

	st.index()
	st.generate_normals()
	st.generate_tangents()
	st.commit(self)


func _add_tooth(st: SurfaceTool, index: int) -> void:
	var current_start_rad = element_rad * index * 2.0
	var ocd = 0.0 # - (element_rad / 2.0)
	#      _____
	#  1  /  2  \
	# ___/       \
	# _____|_____| - 2 * element_rad !
	# ___##_____## - tooth_cheek_percentage from rad
	#
	# _1/2-3\4 - we start with 1 sole\root
	#P1  2 3   4 5 - points
	#
	# \    |     /
	#  \   |    /  shaft_radius, \/ when radius 0.0
	#   ###|####
	#  S1  S2  S3
	
	var p1:Vector2 = _polar(inner_radius,\
		current_start_rad\
		+ ocd\
		)
	var p2:Vector2 = _polar(inner_radius,\
		current_start_rad\
		+ element_rad\
		- (element_rad * (tooth_cheek_percentage / 2.0))
		+ ocd\
		)
	var p3:Vector2 = _polar(outer_radius,\
		current_start_rad\
		+ element_rad
		+ ocd\
		)
	var p4:Vector2 = _polar(outer_radius,\
		current_start_rad\
		+ 2.0 * element_rad\
		- (element_rad * (tooth_cheek_percentage / 2.0))\
		+ ocd\
		)
	var p5:Vector2 = _polar(inner_radius,\
		current_start_rad\
		+ 2.0 * element_rad\
		+ ocd\
		)
	
	var s1:Vector2
	var s2:Vector2
	var s3:Vector2
	if shaft_radius > 0.0:
		s1 = _polar(shaft_radius, current_start_rad + ocd)
		s2 = _polar(shaft_radius, current_start_rad + element_rad + ocd)
		s3 = _polar(shaft_radius, current_start_rad + 2.0 * element_rad + ocd)
	else:
		s1 = Vector2.ZERO
		s2 = Vector2.ZERO
		s3 = Vector2.ZERO
	
	# Note: Redot uses clockwise winding order for front faces of triangle primitive modes.
	_add_quad_sides(st, p1, p2, s2, s1, -delta_z) # sides 1
	_add_quad_sides(st, s1, s2, p2, p1, delta_z) # BACK
	_add_quad_tops(st, s1, s2, delta_z) # inside shaft
	_add_quad_tops(st, p1, p2, -delta_z) # sole  ___/
	
	_add_quad_tops(st, p2, p3, -delta_z) # //
	
	_add_quad_sides(st, p2, p3, p4, p5, -delta_z) # tooth 
	_add_quad_sides(st, p2, p5, p4, p3, delta_z) # BACK
	_add_quad_tops(st, p3, p4, -delta_z) # top /----\
	
	_add_quad_sides(st, p2, p5, s3, s2, -delta_z) # side 2 - electric bool'aloo
	_add_quad_sides(st, p2, s2, s3, p5, delta_z) # BACK
	_add_quad_tops(st, s2, s3, delta_z) # inside shaft
	
	_add_quad_tops(st, p4, p5, -delta_z) # \\

func _polar(r: float, a: float) -> Vector2:
	return Vector2(r * cos(a), r * sin(a))


func _uv_from_vertex(v: Vector3) -> Vector2:
	var angle: float = atan2(v.y, v.x)
	var u: float = fposmod(angle / TAU, 1.0)  # Winkel auf [0,1) „gewrappt“
	var radius: float = Vector2(v.x, v.y).length()
	var vcoord: float = radius / outer_radius
	return Vector2(u, vcoord)


func _add_tri_uv(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3) -> void:
	st.set_uv(_uv_from_vertex(a))
	st.set_smooth_group(-1)
	st.add_vertex(a)

	st.set_uv(_uv_from_vertex(b))
	st.set_smooth_group(-1)
	st.add_vertex(b)

	st.set_uv(_uv_from_vertex(c))
	st.set_smooth_group(-1)
	st.add_vertex(c)


func _add_quad_uv(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3, d: Vector3) -> void:
	_add_tri_uv(st, a, b, c)
	_add_tri_uv(st, a, c, d)


func _add_quad_sides(st: SurfaceTool,\
	a: Vector2, b: Vector2, c: Vector2, d: Vector2, z:float) -> void:
	_add_tri_uv(st, _v3(a,z), _v3(b,z), _v3(c,z))
	_add_tri_uv(st, _v3(a,z), _v3(c,z), _v3(d,z))

func _add_quad_tops(st: SurfaceTool,\
	a: Vector2, b: Vector2, z:float) -> void:
	_add_tri_uv(st, _v3(a,z), _v3(a,-z), _v3(b,-z))
	_add_tri_uv(st, _v3(a,z), _v3(b,-z), _v3(b,z))


func _v3(v: Vector2, z:float) -> Vector3:
	return Vector3(v.x, v.y, z)
