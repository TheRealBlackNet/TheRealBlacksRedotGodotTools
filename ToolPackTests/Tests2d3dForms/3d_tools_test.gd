extends Node3D

@onready var g_1: MeshInstance3D = %G1
@onready var g_2: MeshInstance3D = %G2
@onready var g_3: MeshInstance3D = %G3
@onready var g_4: MeshInstance3D = %G4


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var time:float = 0.0
func _process(delta: float) -> void:
	time = time+delta*1.0
	if time > TAU:
		time = time - PI
	g_1.rotate(Vector3.FORWARD, delta/4.0)
	g_2.rotate(Vector3.FORWARD, -delta/4.0)

	g_3.rotate(Vector3.FORWARD, -delta/2.0)
	g_4.rotate(Vector3.LEFT, delta/16.0)
	
	#var c1:CogMesh = g_1.mesh as CogMesh
	var c2:CogMesh = g_3.mesh as CogMesh
	var c3:CogMesh = g_4.mesh as CogMesh
	
	c2.tooth_count = floori( 9 + sin(time) * 5 )
	#c2._rebuild()

	c3.outer_radius  = 2.0 + sin(time)
	c3.tooth_depth = 0.5 + 0.25 * sin(time * 2.0)
	
	
