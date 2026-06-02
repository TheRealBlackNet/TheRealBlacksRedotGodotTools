class_name MazeGrid

var __internalData:Array
var __geneatorData:MegastructureData
var __rng:RandomNumberGenerator
var __FeaturesToPlace:Dictionary[MapLevelFeatures, float]

signal progress(name:String, progress:float) 

enum MapDirection {NORTH,EAST,WEST,SOUTH,UP,DOWN,ERROR}
enum NodeAttributes {VISITED,WALL,DEAD_END,CROSSING,GAP,BIOME_TYPE,BIOME_LEVEL}
enum MapStringOutput {ASCII,GAP,WEIGHT,EXITS,BIOME,JSON_SAVE}
enum MapLevelFeatures {\
			BIOME_RED, # the rotting of the world\
			BIOME_BLACK, # no lights in this\
			BIOME_GREEN, # roots broke into the map\
			ROOMS, # places with large rooms\
			EXITS} # let player move to other grid.

static func makeNewMaze(data:MegastructureData) -> MazeGrid:
	var grid:MazeGrid = MazeGrid.new()
	grid.__geneatorData = data
	#grid.progress.connect(displayProgress)
	return grid.makeMaze()


func makeMaze():
	__rng = RandomNumberGenerator.new()
	__rng.set_seed(__geneatorData._start_seed_value)

	createGridAndMazeIt(self)
	addExitsToGrid(self)
	fillGridWithBiomes(self)
	progress.emit("Finished", 100.0)
	return self

static func addExitsToGrid(grid:MazeGrid):
	pass

static func fillGridWithBiomes(grid:MazeGrid):
	pass

static func createGridAndMazeIt(grid:MazeGrid):
	##### make nodes and weights:
	for y in range(0, grid.__geneatorData._size_of_map.y):
		var col:Array  = []
		for x in range(0, grid.__geneatorData._size_of_map.x):
			col.push_back(MapNode.makeNode(x,y,\
				grid.__rng.randf_range(grid.__geneatorData._random_range.x,\
				 grid.__geneatorData._random_range.y)))
		## NOW ADD
		grid.__internalData.push_back(col)
		
		if y % 10 == 0:
			grid.progress.emit("Making grid Y: %d" % [y],\
				y * 100.0 / grid.__geneatorData._size_of_map.y)

	grid.progress.emit("MAZING", 0.0)
	grid.mazer(grid.getXY(0,0))
	
	for y in range(0, grid.__geneatorData._size_of_map.y):
		for x in range(0, grid.__geneatorData._size_of_map.x):
			grid.getXY(x,y).updateOptic()
		
		if y % 10 == 0:
			grid.progress.emit("Optics grid Y: %d" % [y],\
				y * 100.0 / grid.__geneatorData._size_of_map.y)

	return grid



### Now make the maze WIKI  https://de.wikipedia.org/wiki/Algorithmus_von_Prim
# rewrote it to be not recursive!
func mazer(startNode: MapNode) -> void:
	startNode.attributes[NodeAttributes.VISITED] = 1
	var stack: Array[MapNode] = [startNode]
	
	var loop:int = 0
	while not stack.is_empty():
		var neighbors:Array
		var currentNode:MapNode = stack[0]
		currentNode.attributes[NodeAttributes.VISITED] = 1
		neighbors = get_unvisited_neighbors(currentNode)
		
		if neighbors.is_empty():
			stack.pop_front()
			continue
			
		neighbors.sort_custom(\
			func(a, b): return absf(a.weight - currentNode.weight)\
		 		< absf(b.weight - currentNode.weight))
		
		connectTwoNodes(currentNode,neighbors[0])
		stack.push_front(neighbors[0])
		
		for currentneighbor:MapNode in neighbors:
			if not currentneighbor.attributes.has(NodeAttributes.VISITED)\
					and __geneatorData._add_shortcuts\
					and abs(abs(currentneighbor.weight - currentNode.weight)\
						- __geneatorData._gap_position)\
								< __geneatorData._gap_range\
					and currentneighbor != neighbors[0]:
				currentNode.attributes[NodeAttributes.GAP] = 1.0
				connectTwoNodes(currentNode,currentneighbor)
		#
		#
		loop+=1
		if loop % 100 == 0:
			progress.emit("MAZING loop: %d " % [loop], loop * 100.0 / \
				(__geneatorData._size_of_map.x * __geneatorData._size_of_map.y))
		


func get_unvisited_neighbors(current:MapNode) -> Array:
	var retval:Array = []
	for v:Vector2i in [\
		Vector2i(-1,0), Vector2i(1,0),\
		Vector2i(0,-1), Vector2i(0,1)]:
			var tmp = getXY(current.pos.x + v.x, current.pos.y + v.y)
			if tmp != null:
				if !tmp.attributes.has(NodeAttributes.VISITED):
					retval.push_back(tmp)
	return retval

func getXY(x:int, y:int) -> MapNode:
	if y >= __internalData.size() or y < 0:
		return null
	var col:Array = __internalData[y]
	if col == null:
		return null
	if x >= col.size() or x < 0:
		return null
	var mnode:MapNode = col[x]
	return mnode

func getSaveString(type:MapStringOutput)->String:
	var ml:String ="\n";
	for y:int in range(0, __geneatorData._size_of_map.y):
		for x:int in range(0, __geneatorData._size_of_map.x):
			var node:MapNode = getXY(x,y)
			if type == MapStringOutput.ASCII or type == null:
				ml += node.optic
			else:
				var color:String = colorFromAttributes(type, node)
				
				if len(color) > 0:
					ml += "[color=" + color + "]"
				ml += node.optic
				if len(color) > 0:
					ml += "[/color]"
		ml+="\n"
	return ml

# DEBUG
static func colorFromAttributes(type:MapStringOutput, n:MapNode) -> String:
	if type == MapStringOutput.GAP \
			and n.attributes.has(NodeAttributes.GAP)\
			and n.attributes[NodeAttributes.GAP] > 0:
		return "RED"
	if type == MapStringOutput.WEIGHT:
		var val:int = roundi(n.weight / 100.0 * 255.0)
		var percent:String = "%x" % val
		
		return "#" + percent + percent + percent # + "ff"
	return "WHITE"


static func connectTwoNodes(current:MapNode,other:MapNode):
	var dir:MapDirection = MapNode.getDir(current,other)
	if dir == MapDirection.NORTH:
		current.north = other
		other.south = current
	elif dir == MapDirection.SOUTH:
		current.south = other
		other.north = current
	elif dir == MapDirection.EAST:
		current.east = other
		other.west = current
	elif dir == MapDirection.WEST:
		current.west = other
		other.east = current
	else:
		# DEBUG
		print("ERROR: CONECT: %s --- %s" % [current.pos, other.pos] )
