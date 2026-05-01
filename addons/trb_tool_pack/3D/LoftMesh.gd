@tool
extends ArrayMesh
class_name LoftMesh

#
# XXXXXXXXXX
#
#
#
#
#
#
##



@export_group("Loft") #LoftNurbs from Cinema4D Form = Form
@export var subdivision:int = 32:
	set(v):
		subdivision = clamp(v, 3, 360*4)
		_rebuild()


func _ready() -> void:
	_rebuild()

func _rebuild() -> void:
	_generate_mesh()

func _generate_mesh() -> void:
	clear_surfaces()
	
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	# Add here #
	
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
