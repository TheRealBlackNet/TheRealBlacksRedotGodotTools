class_name MapNode

enum MapNodeType {Nothing, Wall, Path, Exit}

static var possibleSymbols:String = "█═║╚╗╝╔╩╠╦╣╬▲►▼◄" # ░▒▓█■□

var type:MapNodeType = MapNodeType.Nothing
var attributes:Dictionary[MazeGrid.NodeAttributes, Variant]
var optic:String = "_"

var pos:Vector2i = Vector2i(-1,-1)
var weight:float = -1

# double linked web
var north:MapNode = null
var south:MapNode = null
var west:MapNode = null
var east:MapNode = null

static func makeNode(x:int,y:int,w:float) -> MapNode:
	var retval:MapNode = MapNode.new()
	retval.pos = Vector2i(x,y)
	retval.weight = w
	return retval
	
static func getDir(me:MapNode,other:MapNode) -> MazeGrid.MapDirection:
	if me.pos.x == other.pos.x and me.pos.y <= other.pos.y:
		return MazeGrid.MapDirection.SOUTH
	elif me.pos.x == other.pos.x and me.pos.y >= other.pos.y:
		return MazeGrid.MapDirection.NORTH
	elif me.pos.x <= other.pos.x  and me.pos.y == other.pos.y:
		return MazeGrid.MapDirection.EAST
	elif me.pos.x >= other.pos.x  and me.pos.y == other.pos.y:
		return MazeGrid.MapDirection.WEST
	else:
		return MazeGrid.MapDirection.ERROR

func getNeighbors()->Array[MapNode]:
	var retval:Array[MapNode] = []
	if north != null:
		retval.push_back(north)
	if south != null:
		retval.push_back(south)
	if west != null:
		retval.push_back(west)
	if east != null:
		retval.push_back(east)
	return retval

func updateOptic():
	if north == null and south == null and west == null and east == null:
		optic = "█"
		attributes[MazeGrid.NodeAttributes.WALL] = 1.0
	elif north != null and south != null and west != null and east != null:
		optic = "╬"
		attributes[MazeGrid.NodeAttributes.CROSSING] = 1.0
	elif north != null and south == null and west == null and east == null:
		optic = "▼"
		attributes[MazeGrid.NodeAttributes.DEAD_END] = 1.0
	elif north == null and south != null and west == null and east == null:
		optic = "▲"
		attributes[MazeGrid.NodeAttributes.DEAD_END] = 1.0
	elif north == null and south == null and west != null and east == null:
		optic = "►"
		attributes[MazeGrid.NodeAttributes.DEAD_END] = 1.0
	elif north == null and south == null and west == null and east != null:
		optic = "◄"
		attributes[MazeGrid.NodeAttributes.DEAD_END] = 1.0
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
		# error
		optic = "░"
		attributes[MazeGrid.NodeAttributes.WALL] = 1.0
