extends Control

@onready var nud_seed: SpinBox = %nudSeed
@onready var nud_size_x: SpinBox = %nudSizeX
@onready var nud_size_y: SpinBox = %nudSizeY
@onready var txt_output_1: TextEdit = %txtOutput1
@onready var txt_output_2: RichTextLabel = %txtOutput2
@onready var check_short_cuts: CheckButton = %checkShortCuts
@onready var nud_short_gap: SpinBox = %nudShortGap
@onready var nud_short_range: SpinBox = %nudShortRange


func _process(_delta: float) -> void:
	pass

func _ready() -> void:
	txt_output_2.add_theme_constant_override("line_separation", 0)
	do()

func do() -> void:
	makeMaze(int(%nudSeed.value),\
	 	int(%nudSizeX.value), int(%nudSizeY.value),\
		check_short_cuts.button_pressed,\
		float(nud_short_gap.value), float(nud_short_range.value)
		)

func makeMaze(seedvalue:int, sizeX:int, sizeY:int,\
		addShort:bool, gap:float, range:float ) -> MazeGrid:
	var grid:MazeGrid = MazeGrid.makeNewMaze(\
		seedvalue,sizeX,sizeY,addShort, gap,range)
	
	#for y:int in range(0, grid.__grid_size_y):
	#	for x:int in range(0, grid.__grid_size_x):
	#		ml+= grid.getXY(x,y).optic
	
	txt_output_1.text = grid.getSaveString(true)
	txt_output_2.text = grid.getSaveString(false)
	
	return grid


func _on_nud_seed_value_changed(_value: float) -> void:
	do()

func _on_btn_make_map_button_up() -> void:
	do()

func _on_check_short_cuts_toggled(toggled_on: bool) -> void:
	do()
