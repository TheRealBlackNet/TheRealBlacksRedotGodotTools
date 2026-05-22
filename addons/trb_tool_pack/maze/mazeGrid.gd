class_name MazeGrid

var __internalData:Array
var __exits:Array

var __startSeed:int
var __grid_size_x:int
var __grid_size_y:int

var __add_grapherrors:bool
var __add_grapherrors_value:float
var __add_grapherrors_window:float

enum MapDirection {NORTH,EAST,WEST,SOUTH,UP,DOWN,ERROR}


static func makeNewMaze(seed:int, sizeX:int, sizeY:int,\
		addShort:bool, gap:float, gap_range:float) -> MazeGrid:
	var grid:MazeGrid = MazeGrid.new()
	grid.__startSeed = seed
	grid.__grid_size_x = sizeX
	grid.__grid_size_y = sizeY
	grid.__add_grapherrors = addShort
	grid.__add_grapherrors_value = gap
	grid.__add_grapherrors_window = gap_range
	
	var rng:RandomNumberGenerator = RandomNumberGenerator.new()
	rng.set_seed(seed)
	
	##### make nodes and weights:
	for y in range(0,sizeY):
		var col:Array  = []
		for x in range(0,sizeX):
			col.push_back(MapNode.makeNode(x,y,rng.randf_range(1.0, 100.0)))
		## NOW ADD
		grid.__internalData.push_back(col)

	grid.mazer(grid.getXY(0,0))
	
	for y in range(0,sizeY):
		for x in range(0,sizeX):
			grid.getXY(x,y).updateOptic()


	#print("Test: %3.3f" % grid.getXY(10,10).weight)
	return grid

	### Now make the maze 
	# 1 Given a current cell as a parameter
	# 2 Mark the current cell as visited
	# 3 While the current cell has any unvisited neighbour cells
	#	3.1 Choose one of the unvisited neighbours
	#	3.2 Remove the wall between the current cell and the chosen cell
	#	3.3 Invoke the routine recursively for the chosen cell

func mazer(current:MapNode): #1
	current.visited = true #2
	var neighbors:Array = get_unvisited_neighbors(current) #3
	
	if neighbors.is_empty():
		var debug:String =  getSaveString(false)
		return
		
	#3.1
	neighbors.sort_custom(\
		func(a, b): return absf(a.weight - current.weight)\
		 	< absf(b.weight - current.weight))
	
	#3.2
	var other:MapNode = neighbors[0]
	connectTwoNodes(current,other)
#	var dir:MapDirection = MapNode.getDir(current,other)
#	if dir == MapDirection.NORTH:
#		current.north = other
#		other.south = current
#	elif dir == MapDirection.SOUTH:
#		current.south = other
#		other.north = current
#	elif dir == MapDirection.EAST:
#		current.east = other
#		other.west = current
#	elif dir == MapDirection.WEST:
#		current.west = other
#		other.east = current
	#3.3
	for currentneighbor:MapNode in neighbors:
		if !currentneighbor.visited:
			connectTwoNodes(current,currentneighbor)
		elif __add_grapherrors\
			and abs(abs(currentneighbor.weight - current.weight)\
			 	 - __add_grapherrors_value)\
				 < __add_grapherrors_window:
			current.color = "red"
			connectTwoNodes(current,currentneighbor)
		mazer(currentneighbor)


func get_unvisited_neighbors(current:MapNode) -> Array:
	var retval:Array = []
	for v:Vector2i in [\
		Vector2i(-1,0), Vector2i(1,0),\
		Vector2i(0,-1), Vector2i(0,1)]:
			var tmp = getXY(current.pos_x + v.x, current.pos_y + v.y)
			if tmp != null:
				if !tmp.visited:
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

func getSaveString(plainText:bool)->String:
	var ml:String ="\n";
	for y:int in range(0,__grid_size_y):
		for x:int in range(0,__grid_size_x):
			var node:MapNode = getXY(x,y)
			if plainText:
				ml += node.optic
			else:
				if len(node.color) > 0:
					ml += "[color="+node.color+"]"
				ml += node.optic
				if len(node.color) > 0:
					ml += "[/color]"
		ml+="\n"
	return ml


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
