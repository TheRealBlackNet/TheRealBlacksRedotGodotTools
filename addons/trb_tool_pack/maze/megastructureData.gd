class_name MegastructureData

var _start_seed_value:int
var _size_of_map:Vector2i

var _add_shortcuts:bool
var _gap_position:float
var _gap_range:float

const _random_range:Vector2 = Vector2(1.0, 100.0) # static

static func makeDataBlank() -> MegastructureData:
	var retval:MegastructureData = MegastructureData.new()
	return retval

static func makeDataDefault() -> MegastructureData:
	var retval:MegastructureData = MegastructureData.new()
	retval._start_seed_value = 4563482
	retval._size_of_map = Vector2i(34, 34) # 34 15

	retval._add_shortcuts = true
	retval._gap_position = 33.0
	retval._gap_range = 4.0
	return retval

static func makeDataSize(seed:int,\
			size_x:int, size_y:int\
		) -> MegastructureData:
	var retval:MegastructureData = makeDataBlank()
	retval._start_seed_value = seed
	retval._size_of_map = Vector2i(size_x, size_y)

	retval._add_shortcuts = false
	retval._gap_position = 0.0
	retval._gap_range = 0.0
	return retval

static func makeData(seed:int,\
			size_x:int, size_y:int,\
			create_loops_shortcuts:bool,\
			gap_position:float,\
			gap_size:float\
		) -> MegastructureData:
	var retval:MegastructureData = makeDataSize(seed, size_x, size_y)

	retval._add_shortcuts = create_loops_shortcuts
	retval._gap_position = gap_position
	retval._gap_range = gap_size
	return retval
