class_name UvPrecalc

var uv_slice:Vector2
var uv_slice_w:Vector2
var uv_slice_h:Vector2

var uv_pixel_size:Vector2

var groups:Vector2i
var textures_per_group:Vector2i
var pixels_per_texture:Vector2i

static func make(arg_groups:Vector2i,\
		arg_textures_per_group:Vector2i,\
		arg_pixels_per_texture:Vector2i) -> UvPrecalc:
	var retval:UvPrecalc = UvPrecalc.new()
	retval.groups = arg_groups
	retval.textures_per_group = arg_textures_per_group
	retval.pixels_per_texture = arg_pixels_per_texture
	
	retval.uv_slice = Vector2(\
		1.0 / (arg_groups.x * arg_textures_per_group.x),\
		1.0 / (arg_groups.y * arg_textures_per_group.y))
	retval.uv_pixel_size = Vector2(\
		1.0 / (arg_groups.x * arg_textures_per_group.x * arg_pixels_per_texture.x),\
		1.0 / (arg_groups.y * arg_textures_per_group.y * arg_pixels_per_texture.y))
	
	retval.uv_slice_w = Vector2(retval.uv_slice.x, 0.0)
	retval.uv_slice_h = Vector2(0.0, retval.uv_slice.y)
	
	return retval

func get_uv_quad(group:Vector2i, tex:Vector2i) -> Array[Vector2]:
	var start:Vector2 = Vector2(\
		(group.x * textures_per_group.x + tex.x) * uv_slice.x,\
		(group.y * textures_per_group.y + tex.y) * uv_slice.y )
	return [start, start + uv_slice_w, start+uv_slice, start+uv_slice_h]

	
