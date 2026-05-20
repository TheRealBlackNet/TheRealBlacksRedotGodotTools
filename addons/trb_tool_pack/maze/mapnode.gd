class_name MapNode

enum MapNodeType {Nothing, Wall, Path, Exit}

static var possibleSymbols:String = "█═║╚╗╝╔╩╠╦╣╬▲►▼◄" # ░▒▓█■□

var type:MapNodeType = MapNodeType.Nothing

var optic:String = "_"
var color:String = ""
var pos_x:int = -1
var pos_y:int = -1

var weight:float = -1
var visited:bool = false

var north:MapNode = null
var south:MapNode = null
var west:MapNode = null
var east:MapNode = null


var exitData:Exitdata = null


func updateOptic():
	if north == null and south == null and west == null and east == null:
		optic = "█"
	elif north != null and south != null and west != null and east != null:
		optic = "╬"
	elif north != null and south == null and west == null and east == null:
		optic = "▼"
	elif north == null and south != null and west == null and east == null:
		optic = "▲"
	elif north == null and south == null and west != null and east == null:
		optic = "►"
	elif north == null and south == null and west == null and east != null:
		optic = "◄"
	# two
	elif north != null and south != null and west == null and east == null:
		optic = "║"
	elif north == null and south == null and west != null and east != null:
		optic = "═"
	# A
	elif north != null and south == null and west != null and east == null:
		optic = "╝"
	elif north != null and south == null and west == null and east != null:
		optic = "╚"
	# B
	elif north == null and south != null and west != null and east == null:
		optic = "╗"
	elif north == null and south != null and west == null and east != null:
		optic = "╔"
	# tri ╩ ╠  ╣  
	elif north != null and south == null and west != null and east != null:
		optic = "╩"
	elif north != null and south != null and west == null and east != null:
		optic = "╠"
	elif north != null and south != null and west != null and east == null:
		optic = "╣"
	# ╦
	elif north == null and south != null and west != null and east != null:
		optic = "╦"
	else:
		optic = "░"




static func makeNode(x:int,y:int,w:float) -> MapNode:
	var retval:MapNode = MapNode.new()
	retval.pos_x = x
	retval.pos_y = y
	retval.weight = w
	return retval
	
static func getDir(me:MapNode,other:MapNode) -> MazeGrid.MapDirection:
	if me.pos_x == other.pos_x and me.pos_y <= other.pos_y:
		return MazeGrid.MapDirection.SOUTH
	elif me.pos_x == other.pos_x and me.pos_y >= other.pos_y:
		return MazeGrid.MapDirection.NORTH
	elif me.pos_x <= other.pos_x  and me.pos_y == other.pos_y:
		return MazeGrid.MapDirection.EAST
	elif me.pos_x >= other.pos_x  and me.pos_y == other.pos_y:
		return MazeGrid.MapDirection.WEST
	else:
		return MazeGrid.MapDirection.ERROR
