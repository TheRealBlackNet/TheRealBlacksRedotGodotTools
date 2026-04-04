@tool
extends ArrayMesh
class_name LatheMesh

@export_group("Lathe") #LatheNurbs from Cinema4D 
@export var spline:Curve3D:
	set(v):
		spline = v
		if spline and !spline.changed.is_connected(_rebuild):
			spline.changed.connect(_rebuild)
		_rebuild()

@export var subdivision:int = 32:
	set(v):
		subdivision = clamp(v, 3, 360*4)
		_rebuild()

@export var angle_grad:int = 360:
	set(v):
		angle_grad = clamp(v, 1, 360)
		_rebuild()

@export var axis:Vector3 = Vector3.UP:
	set(v):
		axis = v
		_rebuild()


func _ready() -> void:
	if Engine.is_editor_hint():
		_rebuild()

func _rebuild() -> void:
	print("_rebuild")
	_generate_mesh()


func _generate_mesh() -> void:
	if spline == null or spline.point_count < 2:
		print("EXIT")
		return

	clear_surfaces()

	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var deltaRad: float = deg_to_rad(angle_grad)  / float(subdivision)

	for index in range(1,spline.point_count): # rings
		var currentPoint:Vector3 = spline.get_point_position(index)
		var lastPoint:Vector3 = spline.get_point_position(index-1)
		
		var p1:Vector3 = currentPoint
		var p2:Vector3 = lastPoint
		var p3:Vector3 = Vector3(lastPoint).rotated(axis, deltaRad)
		var p4:Vector3 = Vector3(currentPoint).rotated(axis, deltaRad)
		
		_add_quad_uv(st, p1, p4, p3, p2)
	
		# Y+ Version:
		for i in range(1,subdivision): # slices
			p1 = p4
			p2 = p3
			p3 = p3.rotated(axis, deltaRad)
			p4 = p4.rotated(axis, deltaRad)
			_add_quad_uv(st, p1, p4, p3, p2)

	st.index()
	st.generate_normals()
	st.generate_tangents()
	st.commit(self)




func _polar(r: float, a: float) -> Vector2:
	return Vector2(r * cos(a), r * sin(a))

func _uv_from_vertex(v: Vector3) -> Vector2:
	var angle: float = atan2(v.y, v.x)
	var u: float = fposmod(angle / TAU, 1.0)  # Winkel auf [0,1) „gewrappt“
	var radius: float = Vector2(v.x, v.y).length()
	var vcoord: float = 1.0
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

func _add_quad_uv(st: SurfaceTool,\
	a: Vector3, b: Vector3,\
	c: Vector3, d: Vector3) -> void:
	_add_tri_uv(st, a, b, c)
	_add_tri_uv(st, a, c, d)
