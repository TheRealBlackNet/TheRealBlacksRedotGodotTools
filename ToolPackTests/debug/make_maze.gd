extends Control

@onready var nud_seed: SpinBox = %nudSeed
@onready var nud_size_x: SpinBox = %nudSizeX
@onready var nud_size_y: SpinBox = %nudSizeY
@onready var txt_output_1: TextEdit = %txtOutput1
@onready var txt_output_2: RichTextLabel = %txtOutput2
@onready var check_short_cuts: CheckButton = %checkShortCuts
@onready var nud_short_gap: SpinBox = %nudShortGap
@onready var nud_short_range: SpinBox = %nudShortRange
@onready var txt_output_3: RichTextLabel = %txtOutput3
@onready var txt_output_4: RichTextLabel = %txtOutput4
@onready var txt_output_5: RichTextLabel = %txtOutput5
@onready var txt_output_x: RichTextLabel = %txtOutputX
@onready var nud_street_bias: SpinBox = %nudStreetBias
@onready var txt_street_bias: RichTextLabel = %txtStreetBias



func do() -> void:
	makeMaze(\
		int(nud_seed.value),\
	 	int(nud_size_x.value),\
		int(nud_size_y.value),\
		check_short_cuts.button_pressed,\
		float(nud_short_gap.value),\
		float(nud_short_range.value),\
		float(nud_street_bias.value)\
		)

func makeMaze(seedvalue:int,\
		sizeX:int, sizeY:int,\
		addShort:bool, gap:float, gaprange:float, street:float ) -> MazeGrid:
	
	var data:MegastructureData = MegastructureData.makeData(\
			seedvalue, sizeX, sizeY, addShort, gap, gaprange, street)
	var grid:MazeGrid = MazeGrid.makeNewMaze(data)

	txt_output_1.text = grid.getSaveString(MazeGrid.MapStringOutput.ASCII)
	txt_output_2.text = grid.getSaveString(MazeGrid.MapStringOutput.GAP)
	txt_output_3.text = grid.getSaveString(MazeGrid.MapStringOutput.WEIGHT)
	txt_output_4.text = grid.getSaveString(MazeGrid.MapStringOutput.EXITS)
	txt_output_5.text = grid.getSaveString(MazeGrid.MapStringOutput.BIOME)
	txt_output_x.text = grid.getSaveString(MazeGrid.MapStringOutput.JSON_SAVE)
	txt_street_bias.text = grid.getSaveString(MazeGrid.MapStringOutput.STREET)
	
	return grid


func _ready() -> void:
	txt_output_2.add_theme_constant_override("line_separation", 0)
	do()

func _on_nud_seed_value_changed(_value: float) -> void:
	do()

func _on_btn_make_map_button_up() -> void:
	do()

func _on_check_short_cuts_toggled(_toggled_on: bool) -> void:
	do()
