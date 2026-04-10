@tool
extends MeshInstance3D
class_name LoftMeshInstance3D

@export_category("Debug")
@export var dummy:bool = true:
	set(v):
		dummy = v
		_rebuild()

func _ready() -> void:
	if self.mesh == null:
		self.mesh = ArrayMesh.new()
	
	self.child_order_changed.connect(_rebuild)
	self.child_entered_tree.connect(_newchild)
	self.child_exiting_tree.connect(_delchild)

func _delchild(node: Node):
	if node is Path3D:
		(node as Path3D).curve_changed.disconnect(_rebuild)
	_rebuild()

func _newchild(node: Node):
	if node is Path3D:
		(node as Path3D).curve_changed.connect(_rebuild)
	_rebuild()

func _rebuild():
	var cnt:int = self.get_child_count(false)
	
	if self.get_child_count(false) >= 2:
		self.mesh.clear_surfaces()
		var st := SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
		for i:int in range(1,cnt):
			print("_rebuild:" + str(i-1) + " # " + str(i))
			_generate_mesh(st,\
				(self.get_child(i-1) as Path3D).curve,\
				(self.get_child(i) as Path3D).curve )
		
		st.index()
		st.generate_normals()
		st.generate_tangents()
		st.commit(self.mesh)


func _generate_mesh(st:SurfaceTool, a:Curve3D, b:Curve3D) -> void:
	# create loft between Curve3D a and b
	# Anzahl der Samples pro Kurve (gleichmäßig verteilen)
	var samples:float = 2.0 * max(\
			a.get_point_count(), b.get_point_count())
	if samples < 2:
		return
	# Beide Kurven auf gleiche Anzahl interpolieren
	var pts_a: Array[Vector3] = []
	var pts_b: Array[Vector3] = []
	
	for i in range(samples):
		print("samples:" + str(i) + " # " + str(samples))
		var ta = a.get_baked_length() / samples * i 
		var tb = b.get_baked_length() / samples * i
		pts_a.append(a.sample_baked(ta,true))
		pts_b.append(b.sample_baked(tb,true))

	# Quads triangulieren
	for i in range(samples - 1):
		var a1 := pts_a[i]
		var a2 := pts_a[i + 1]
		var b1 := pts_b[i]
		var b2 := pts_b[i + 1]
		# Quad: a1 → a2 → b2 → b1
		_add_quad_uv(st, a1, a2, b2, b1)
	
	# close ring
	var a1 := pts_a[samples - 1]
	var a2 := pts_a[0]
	var b1 := pts_b[samples - 1]
	var b2 := pts_b[0]
	# Quad: a1 → a2 → b2 → b1
	_add_quad_uv(st, a1, a2, b2, b1)
	


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
