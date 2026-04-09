@tool
extends ArrayMesh
class_name ArrowMesh

	#    2 _____| 3                 |  _____/ head_set_back -----    
	#     /    /          5         |       --- head_lenght 
	#   a/   4-----------|          | Height   | Shaft_Height_percent
	#  1*   4'___________|          |          |
	#   a\    \           5'        |              // Depth
	#     \----|                    |   Length    //
	#     2'   3'                   ##################
	
@export_group("Arrow")
@export var head_angle_grad:float = 45:
	set(v):
		head_angle_grad = clamp(v, 0, 80)
		_rebuild()

@export var head_lenght:float = 1.0:
	set(v):
		head_lenght = v
		_rebuild()

@export var length:float = 4.0:
	set(v):
		length = v
		_rebuild()

@export var height:float = 2.0:
	set(v):
		height = v
		_rebuild()

@export var depth:float = 1.0:
	set(v):
		depth = v
		_rebuild()

@export var shaft_height:float = 0.5:
	set(v):
		shaft_height = v
		_rebuild()

enum HeadType {Parallel, Flat}
@export var head_type:HeadType = HeadType.Parallel:
	set(v):
		head_type = v
		_rebuild()

func _ready() -> void:
	#if Engine.is_editor_hint():
	_rebuild()

func _rebuild() -> void:
	print("_rebuild")
	_generate_mesh()


func _generate_mesh() -> void:
	clear_surfaces()

	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	var d:float = depth/2.0
	
	var p1:Vector2 = Vector2(length / 2.0, 0)
	var setBack:float = tan(deg_to_rad(head_angle_grad)) * (height / 2.0)
	var p2:Vector2 = Vector2(length / 2.0 - setBack, height / 2.0)
	var p3:Vector2 = Vector2(length / 2.0 - setBack - head_lenght, height / 2.0)
	var p5:Vector2 = Vector2(- length / 2.0, shaft_height / 2.0)
	
	var p4:Vector2 = Vector2(\
		length / 2.0 - setBack - head_lenght\
		+ tan(deg_to_rad(head_angle_grad)) * ((height-shaft_height) / 2.0),\
		shaft_height / 2.0 )
		
	if head_lenght == 0.0 or head_type == HeadType.Flat:
		p4 = Vector2(length / 2.0 - setBack - head_lenght, shaft_height / 2.0)
	
	var p1x:Vector2 = Vector2(p1.x, -p1.y)
	var p2x:Vector2 = Vector2(p2.x, -p2.y)
	var p3x:Vector2 = Vector2(p3.x, -p3.y)
	var p4x:Vector2 = Vector2(p4.x, -p4.y)
	var p5x:Vector2 = Vector2(p5.x, -p5.y)
	
	
	#    2 _____| 3                 |  _____/ head_set_back -----    
	#     /    /          5         |       --- head_lenght 
	#    /   4-----------|          | height   | shaft_Height_percent
	#  1*   4'___________|          |          |
	#    \    \           5'        |              // depth
	#     \----|                    |   length    //
	#     2'   3'                   ##################
	
	_add_quad_uv(st, _v3(p1,-d),_v3(p2,-d),_v3(p3,-d),_v3(p4,-d))
	_add_tri_uv(st, _v3(p1,-d),_v3(p4,-d),_v3(p4x,-d))
	_add_quad_uv(st, _v3(p4,-d),_v3(p5,-d),_v3(p5x,-d),_v3(p4x,-d))
	_add_quad_uv(st, _v3(p1,-d),_v3(p4x,-d),_v3(p3x,-d),_v3(p2x,-d))
	
	_add_quad_uv(st, _v3(p1,d),_v3(p4,d),_v3(p3,d),_v3(p2,d))
	_add_tri_uv(st, _v3(p1,d),_v3(p4x,d),_v3(p4,d))
	_add_quad_uv(st, _v3(p4,d),_v3(p4x,d),_v3(p5x,d),_v3(p5,d))
	_add_quad_uv(st, _v3(p1,d),_v3(p2x,d),_v3(p3x,d),_v3(p4x,d))
	
	_add_quad_uv(st, _v3(p1,-d),_v3(p1,d),_v3(p2,d),_v3(p2,-d))
	_add_quad_uv(st, _v3(p2,-d),_v3(p2,d),_v3(p3,d),_v3(p3,-d))
	_add_quad_uv(st, _v3(p3,-d),_v3(p3,d),_v3(p4,d),_v3(p4,-d))
	_add_quad_uv(st, _v3(p4,-d),_v3(p4,d),_v3(p5,d),_v3(p5,-d))
	
	_add_quad_uv(st, _v3(p5,-d),_v3(p5,d),_v3(p5x,d),_v3(p5x,-d))
	
	_add_quad_uv(st, _v3(p5x,-d),_v3(p5x,d),_v3(p4x,d),_v3(p4x,-d))
	_add_quad_uv(st, _v3(p4x,-d),_v3(p4x,d),_v3(p3x,d),_v3(p3x,-d))
	_add_quad_uv(st, _v3(p3x,-d),_v3(p3x,d),_v3(p2x,d),_v3(p2x,-d))
	_add_quad_uv(st, _v3(p2x,-d),_v3(p2x,d),_v3(p1x,d),_v3(p1x,-d))
	
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

func _v3(v: Vector2, z:float) -> Vector3:
	return Vector3(v.x, v.y, z)
