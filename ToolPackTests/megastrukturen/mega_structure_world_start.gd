extends Node3D

@onready var megastructure: Megastructure = %Megastructure


func _ready() -> void:
	megastructure.data = MegastructureData.makeDataDefault() 
	megastructure.makeMesh()
	print("\r\n")
	print(megastructure.currentGrid.getSaveString(MazeGrid.MapStringOutput.ASCII))
	print("\r\n")

func _process(_delta: float) -> void:
	pass
