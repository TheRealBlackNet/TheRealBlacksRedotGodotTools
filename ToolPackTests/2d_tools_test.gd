extends Node2D

@onready var path: Path2D = $Node2D/Path2D2_Mov1 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(deta: float) -> void:
	var curve1:SinusCurve2D = path.curve as SinusCurve2D
	
	curve1.deltaTime += deta
