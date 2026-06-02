@tool
extends MeshInstance3D
class_name Megastructure

var data:MegastructureData
var currentGrid:MazeGrid

var lightcollection:Node3D
var collision_shape_3d:CollisionShape3D
var static_body:StaticBody3D


func _ready() -> void:
	lightcollection = Node3D.new()
	lightcollection.name = "lightcollection"
	self.add_child(lightcollection,true)
	
	static_body = StaticBody3D.new()
	static_body.name = "MapBody"
	self.add_child(static_body,true)
	
	collision_shape_3d = CollisionShape3D.new()
	collision_shape_3d.name = "collision_shape_3d"
	static_body.add_child(collision_shape_3d,true)


func makeMesh():
	if mesh == null:
		mesh = ArrayMesh.new()
	data = MegastructureData.makeDataDefault()
	data = MegastructureData.makeData(16378,40,40, true, 50.0,2.0)
	currentGrid = MazeGrid.makeNewMaze(data)
	mesh.clear_surfaces()

	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var debug = currentGrid.__geneatorData._size_of_map.y
	for y in range(0, currentGrid.__geneatorData._size_of_map.y):
		for x in range(0, currentGrid.__geneatorData._size_of_map.x):
			meshTile(st, currentGrid.getXY(x,y))

	st.index()
	st.generate_normals()
	st.generate_tangents()
	st.commit(mesh)
	
	collision_shape_3d.shape = mesh.create_trimesh_shape()
	

var elementSizeX:float = 5.0
var elementSizeY:float = 5.0
var wall = 0.5

var roomHeight = 6.0

func meshTile(st:SurfaceTool, node:MapNode):
	var ox:float = elementSizeX * node.pos.x
	var oz:float = elementSizeY * node.pos.y
	
	var n:float = 0.0
	var s:float = 0.0
	var e:float = 0.0
	var w:float = 0.0
	
	if node.north == null:
		n = wall
	if node.south == null:
		s = wall
	if node.west == null:
		w = wall
	if node.east == null:
		e = wall
	
	#	+--+			   +   XXXX+
	#	| /			  /|		Z
	#	|/			 / |		Z
	#	+			+--+		Z+
	_add_tri_uv(st,\
		Vector3(ox + w, 					0,	oz + n 				),\
		Vector3(ox - e + elementSizeX,	0,	oz + n 				),\
		Vector3(ox + w,				 	0,	oz - s + elementSizeY))

	_add_tri_uv(st,\
		Vector3(ox - e + elementSizeX,	0,	oz + n				),\
		Vector3(ox - e + elementSizeX,	0,	oz - s + elementSizeY),\
		Vector3(ox + w, 					0,	oz - s + elementSizeY))

	if node.north == null:
		_add_tri_uv(st,\
			Vector3(ox + w, 					0,	oz + n 				),\
			Vector3(ox + w, 					roomHeight,	oz + n 				),\
			Vector3(ox - e + elementSizeX,	0,	oz + n 				))
		_add_tri_uv(st,\
			Vector3(ox + w, 					roomHeight,	oz + n 				),\
			Vector3(ox - e + elementSizeX,	roomHeight,	oz + n 				),\
			Vector3(ox - e + elementSizeX,	0,	oz + n 				))
	if node.south == null:
		_add_tri_uv(st,\
			Vector3(ox + w,				 	0,	oz - s + elementSizeY),\
			Vector3(ox - e + elementSizeX,	roomHeight,	oz - s + elementSizeY),\
			Vector3(ox + w,				 	roomHeight,	oz - s + elementSizeY))
		_add_tri_uv(st,\
			Vector3(ox - e + elementSizeX,	roomHeight,	oz - s + elementSizeY),\
			Vector3(ox + w,				 	0,	oz - s + elementSizeY),\
			Vector3(ox - e + elementSizeX,	0,	oz - s + elementSizeY))
	if node.west == null:
		_add_tri_uv(st,\
			Vector3(ox + w, 					roomHeight,	oz + n 				),\
			Vector3(ox + w, 					0,	oz + n 				),\
			Vector3(ox + w,				 	0,	oz - s + elementSizeY))
		_add_tri_uv(st,\
			Vector3(ox + w, 					roomHeight,	oz + n 				),\
			Vector3(ox + w,				 	0,	oz - s + elementSizeY),\
			Vector3(ox + w,				 	roomHeight,	oz - s + elementSizeY))
	if node.east == null:
		_add_tri_uv(st,\
			Vector3(ox - e + elementSizeX,	0,	oz + n 				),\
			Vector3(ox - e + elementSizeX,	roomHeight,	oz + n 				),\
			Vector3(ox - e + elementSizeX,				 	0,	oz - s + elementSizeY))
		_add_tri_uv(st,\
			Vector3(ox - e + elementSizeX,	roomHeight,	oz + n 				),\
			Vector3(ox - e + elementSizeX,	roomHeight,	oz - s + elementSizeY),\
			Vector3(ox - e + elementSizeX,	0,	oz - s + elementSizeY))




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

func _add_quad_uv(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3, d: Vector3) -> void:
	_add_tri_uv(st, a, b, c)
	_add_tri_uv(st, a, c, d)
