class_name MazeGrid

var __internalData:Array
var __geneatorData:MegastructureData
var __rng:RandomNumberGenerator
var __FeaturesToPlace:Dictionary[MapLevelFeatures, float]

enum MapDirection {NORTH,EAST,WEST,SOUTH,UP,DOWN,ERROR}
enum NodeAttributes {VISITED,WALL,DEAD_END,CROSSING,GAP,BIOME_TYPE,BIOME_LEVEL}
enum MapStringOutput {ASCII,GAP,WEIGHT,EXITS,BIOME,JSON_SAVE}
enum MapLevelFeatures {\
			BIOME_RED, # the rotting of the world\
			BIOME_BLACK, # no lights in this\
			BIOME_GREEN, # roots broke into the map\
			ROOMS, # places with large rooms\
			EXITS} # let player move to other grid.


static func makeNewMaze(seed:int,\
		sizeX:int, sizeY:int,\
		addShort:bool, gap:float, gap_range:float\
		,versionB:bool) -> MazeGrid:
			
	var grid:MazeGrid = MazeGrid.new()
	grid.__geneatorData = MegastructureData.makeData(\
			seed,\
			sizeX, sizeY,\
			addShort, gap, gap_range)
	grid.__geneatorData._version_b = versionB
	return grid.makeMaze()

static func makeMazeByData(data:MegastructureData) -> MazeGrid:
	var grid:MazeGrid = MazeGrid.new()
	grid.__geneatorData = data
	return grid.makeMaze()



func makeMaze():
	__rng = RandomNumberGenerator.new()
	__rng.set_seed(__geneatorData._start_seed_value)

	createGridAndMazeIt(self)
	addExitsToGrid(self)
	fillGridWithBiomes(self)
	
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

	if grid.__geneatorData._version_b:
		grid.mazer_iterative(grid.getXY(0,0))
	else:
		grid.mazer(grid.getXY(0,0))
	
	for y in range(0, grid.__geneatorData._size_of_map.y):
		for x in range(0, grid.__geneatorData._size_of_map.x):
			grid.getXY(x,y).updateOptic()

	return grid



### Now make the maze WIKI  https://de.wikipedia.org/wiki/Algorithmus_von_Prim
# 1 Given a current cell as a parameter
# 2 Mark the current cell as visited
# 3 While the current cell has any unvisited neighbour cells
#	3.1 Choose one of the unvisited neighbours
#	3.2 Remove the wall between the current cell and the chosen cell
#	3.3 Invoke the routine recursively for the chosen cell
func mazer(current:MapNode): #1
	current.attributes[NodeAttributes.VISITED] = 1 #2
	var neighbors:Array = get_unvisited_neighbors(current) #3
	
	#3.1
	neighbors.sort_custom(\
		func(a, b): return absf(a.weight - current.weight)\
		 	< absf(b.weight - current.weight))
	
	if neighbors.is_empty():
		return
	#3.2
	var other:MapNode = neighbors[0]
	connectTwoNodes(current,other)
	#3.3
	for currentneighbor:MapNode in neighbors:
		if !currentneighbor.attributes.has(NodeAttributes.VISITED):
			connectTwoNodes(current,currentneighbor)
		# add graph errors (loops)
		elif __geneatorData._add_shortcuts\
			and abs(abs(currentneighbor.weight - current.weight)\
			 	 - __geneatorData._gap_position)\
				 < __geneatorData._gap_range:
			current.attributes[NodeAttributes.GAP] = 1.0
			connectTwoNodes(current,currentneighbor)
		mazer(currentneighbor)

func mazer_iterative(startNode: MapNode) -> void:
	startNode.attributes[NodeAttributes.VISITED] = 1
	var stack: Array[MapNode] = [startNode]
	
	var loop:int = 0
	while not stack.is_empty():
		if stack.size() > 2300 or loop > 2300:
			return
		
		loop+=1
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
						< __geneatorData._gap_range:
				currentNode.attributes[NodeAttributes.GAP] = 1.0
				connectTwoNodes(currentNode,currentneighbor)
		
		
	


func mazer_iterative_x1(startNode: MapNode) -> void:
	startNode.attributes[NodeAttributes.VISITED] = 1
	var neighbors:Array
	var currentNode:MapNode
	var nextNode:MapNode
	var lastNode:MapNode
	var stack: Array[MapNode] = [startNode]
	var loops:int = 0

	while not stack.is_empty():
		loops += 1
		if loops > 10000:
			return
		
		currentNode = stack.pop_front()
		if currentNode == null:
			continue
		currentNode.attributes[NodeAttributes.VISITED] = 1
		
		# if currentNode.pos == Vector2i(0,3):
		if stack.size() > 0:
			print("LOOP: %s NODE: %s - STACK %s" % [loops, currentNode.pos, stack[0].pos ])
		else:
			print("LOOP: %s NODE: %s - STACK --" % [loops, currentNode.pos ])
		
		neighbors = get_unvisited_neighbors(currentNode)
		
		if neighbors.is_empty():
			continue
		
		neighbors.sort_custom(\
			func(a, b): return absf(a.weight - currentNode.weight)\
		 		< absf(b.weight - currentNode.weight))
		
		while not neighbors.is_empty():
			stack.push_front(neighbors.pop_back())
		
		#if lastNode != null:
		#	stack.push_front(lastNode)
		#stack.push_front(currentNode)
		
		nextNode = stack[0]
		nextNode.attributes[NodeAttributes.VISITED] = 1
		connectTwoNodes(nextNode,currentNode)
		lastNode = currentNode


func mazer_iterative_cop(startNode: MapNode) -> void:
	var stack: Array[MapNode] = [startNode]
	while not stack.is_empty():
		var current: MapNode = stack.pop_back()
		# 1: Mark as visited
		current.attributes[NodeAttributes.VISITED] = 1
		# 2: Get neighbors
		var neighbors: Array = get_unvisited_neighbors(current)

		if neighbors.is_empty():
			continue
		# 3.1 Sort neighbors by weight distance
		neighbors.sort_custom(
			func(a, b):
				return absf(a.weight - current.weight)\
				 	< absf(b.weight - current.weight)
		)

		# 3.2 Connect to the first neighbor
		var other: MapNode = neighbors[0]
		connectTwoNodes(current, other)
		stack.push_front(other)
		# 3.3 Process all neighbors
		for currentneighbor: MapNode in neighbors:
			if !currentneighbor.attributes.has(NodeAttributes.VISITED):
				connectTwoNodes(current, currentneighbor)
				# Push unvisited neighbor to stack
				stack.push_back(currentneighbor)
			# Add shortcuts (loops)
			elif __geneatorData._add_shortcuts \
				and abs(abs(currentneighbor.weight - current.weight)
					- __geneatorData._gap_position) \
					< __geneatorData._gap_range:
				current.attributes[NodeAttributes.GAP] = 1.0
				connectTwoNodes(current, currentneighbor)



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
		print("ERROR: CONECT: %s --- %s" % [current.pos, other.pos] )
