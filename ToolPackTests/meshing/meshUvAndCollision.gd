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

@export var titleSize:float = 2.5

@export var remake:bool = true:
	set(x):
		do()

func _ready() -> void:
	do()

func do() -> void:
	var uvPre:UvPrecalc = UvPrecalc.make(groups, textures_per_group, pixels_per_texture)
	
	if mesh == null:
		mesh = ArrayMesh.new()
	(mesh as ArrayMesh).clear_surfaces()

	var st:SurfaceTool = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	#var uvQ:Array[Vector2] = uvPre.get_uv_quad(Vector2i(0,0), Vector2i(0,0))
	
	for gx:int in range(0, groups.x):
		for gy:int in range(0, groups.y):
			for tx:int in range(0, textures_per_group.x):
				for ty:int in range(0, textures_per_group.y):
					Meshing._add_quad(st,\
						Vector3(gx * textures_per_group.x * titleSize + tx * titleSize,\
								0,\
								gy * textures_per_group.x * titleSize + ty * titleSize),\
						Vector3(gx * textures_per_group.x * titleSize + (tx+1) * titleSize,\
								0,\
								gy * textures_per_group.x * titleSize + ty * titleSize),\
						Vector3(gx * textures_per_group.x * titleSize + (tx+1) * titleSize,\
								0,\
								gy * textures_per_group.x * titleSize + (ty+1) * titleSize),\
						Vector3(gx * textures_per_group.x * titleSize + tx * titleSize,\
								0,\
								gy * textures_per_group.x * titleSize + (ty+1) * titleSize),\
						uvPre,\
						Vector2i(gx,gy),\
						Vector2i(tx,ty))
	
	st.index()
	st.generate_normals()
	st.generate_tangents()
	st.commit((mesh as ArrayMesh))
	
	shape3D.shape = mesh.create_trimesh_shape()
