@tool
extends MeshInstance3D
class_name XXXXXXXX

@export_category("Mesh")
@export var shape3D:CollisionShape3D
@export_category("Texture")
@export var texture_path:String = "res://addons/trb_tool_pack/res/UV_Color_Map_CleanCarpetDirtPanel.png"
@export var groups:Vector2i = Vector2i(2,2)
@export var textures_per_group:Vector2i = Vector2i(8, 8)
@export var pixels_per_texture:Vector2i = Vector2i(125, 125)


func _ready() -> void:
	var uvPre:UvPrecalc = UvPrecalc.make(groups, textures_per_group, pixels_per_texture)
	
	if mesh == null:
		mesh = ArrayMesh.new()
	mesh.clear_surfaces()

	var st:SurfaceTool = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	#var uvQ:Array[Vector2] = uvPre.get_uv_quad(Vector2i(0,0), Vector2i(0,0))
	
	Meshing._add_quad(st,\
		Vector3(0,0,0),\
		Vector3(5,0,0),\
		Vector3(5,0,5),\
		Vector3(0,0,5),\
		uvPre,\
		Vector2i(0,0),\
		Vector2i(0,0))
	
	st.index()
	st.generate_normals()
	st.generate_tangents()
	st.commit(mesh)
	
	shape3D.shape = mesh.create_trimesh_shape()
