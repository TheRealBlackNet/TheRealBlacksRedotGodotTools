extends Node2D

@onready var path_2d_2: Path2D = $Path2D2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(deta: float) -> void:
	var curve1:SinusCurve2D = path_2d_2.curve as SinusCurve2D
	
	curve1.deltaTime += deta
