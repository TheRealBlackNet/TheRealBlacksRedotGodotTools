@tool
extends MeshInstance3D
class_name Meshing


static func _add_quad(st:SurfaceTool,\
		a:Vector3, b:Vector3, c:Vector3, d:Vector3,\
		pre:UvPrecalc, group:Vector2i, texture:Vector2i) -> void:
	
	var uv:Array[Vector2] = pre.get_uv_quad(group, texture)
	
	st.set_uv(uv[0])
	st.set_smooth_group(-1)
	st.add_vertex(a)

	st.set_uv(uv[1])
	st.set_smooth_group(-1)
	st.add_vertex(b)

	st.set_uv(uv[2])
	st.set_smooth_group(-1)
	st.add_vertex(c)


	st.set_uv(uv[0])
	st.set_smooth_group(-1)
	st.add_vertex(a)

	st.set_uv(uv[2])
	st.set_smooth_group(-1)
	st.add_vertex(c)
	
	st.set_uv(uv[3])
	st.set_smooth_group(-1)
	st.add_vertex(d)
