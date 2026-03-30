@tool
extends Node2D
class_name PlacerOnSpline2D


#@export var spline: Path2D:
#	set(value):
#		spline = value
#		_update_instances()

@export var scene_to_place: PackedScene:
	set(value):
		scene_to_place = value
		_update_instances()

@export var count: int = 5:
	set(value):
		count = max(0, value)
		_update_instances()

# Internal list of placed nodes
var placed_nodes: Array[Node] = []
var spline: Path2D
var groupNode:Node2D

func _ready() -> void:
	if Engine.is_editor_hint():
		_setExistingNodes()
		_ensure_group_exists()
		_ensure_spline_exists()
		_update_instances()

func _setExistingNodes() -> void:
	if spline == null or groupNode == null:
		for node:Node in get_children(false):
			if node is Node2D:
				groupNode = node
			elif node is Path2D:
				spline = node


func _notification(what) -> void:
	print("xxxx: " + str(what))
	if what == NOTIFICATION_POSTINITIALIZE:
		_update_instances()


func _update_instances() -> void:
	if not Engine.is_editor_hint():
		return
	
	_ensure_group_exists()
	_ensure_spline_exists()
	
	if scene_to_place == null\
			or spline == null\
			or spline.curve == null:
		return
	
	if spline.position.length() > 0:
		spline.position = Vector2.ZERO
	
	
	if !spline.curve.changed.is_connected(_update_instances):
		spline.curve.changed.connect(_update_instances)

	if placed_nodes.size() != count:
		_redoInstances()
	else:
		_moveInstances()


func _moveInstances() -> void:
	var curve := spline.curve
	if curve == null:
		return

	var total_length := curve.get_baked_length()
	if total_length <= 0 or count <= 0:
		return
	
	
	for i in range(count):
		var t := float(i) / float(count - 1) if count > 1 else 0.0
		var dist := t * total_length
		var pos = curve.sample_baked(dist)

		var inst := groupNode.get_child(i)
		#inst.name = "%s_%d" % [scene_to_place.\
		#	resource_path.get_file().get_basename(), i]
		inst.position = pos


func _redoInstances() -> void:
	# Remove old instances
	for n in placed_nodes:
		if is_instance_valid(n):
			#n.queue_free() # causes name collisions AVOID!
			n.free()
	placed_nodes.clear()

	var curve := spline.curve
	if curve == null:
		return

	var total_length := curve.get_baked_length()
	if total_length <= 0 or count <= 0:
		return

	# Place instances at equal distances along the curve
	for i in range(count):
		var t := float(i) / float(count - 1) if count > 1 else 0.0
		var dist := t * total_length
		var pos = curve.sample_baked(dist)

		var inst := scene_to_place.instantiate()
		inst.name = "%s_%d" % [scene_to_place.\
			resource_path.get_file().get_basename(), i]
		groupNode.add_child(inst)
		# MUST BE BELOW ADD_CHILD
		inst.owner = get_tree().edited_scene_root
		inst.position = pos

		placed_nodes.append(inst)


func _ensure_spline_exists() -> void:
	if spline and is_instance_valid(spline):
		return

	spline = Path2D.new()
	spline.name = "Spline-Editor"
	add_child(spline)
	#needs to be AFTER add_child!
	spline.owner = get_tree().edited_scene_root

	# Give it a default curve if empty
	if spline.curve == null:
		var c := Curve2D.new()
		c.add_point(Vector2.ZERO)
		c.add_point(Vector2(200, 0))
		spline.curve = c

func _ensure_group_exists() -> void:
	if groupNode and is_instance_valid(groupNode):
		return
	
	groupNode = Node2D.new()
	groupNode.name = "Instances"
	add_child(groupNode)
	groupNode.owner = get_tree().edited_scene_root
	
