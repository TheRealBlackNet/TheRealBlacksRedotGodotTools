extends Node2D

@onready var path: Path2D = %Path2D2_Mov1_Master
@onready var spline_editor_2: Path2D = %Path2D3_Moving2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(deta: float) -> void:
	var curve1:SinusCurve2D = path.curve as SinusCurve2D
	curve1.delta_time += deta
	var curve2:SinusCurve2D =spline_editor_2.curve as SinusCurve2D
	curve2.delta_time += deta/2.0
