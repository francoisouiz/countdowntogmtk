extends Node2D

@export var _dimensions: Vector2i = Vector2i(7, 5)
@export var _number_of_rooms: int = 10

@onready var start_room = preload("res://scenes/rooms/start_room.tscn")

enum RoomType { START, NORMAL, SPECIAL }

var rooms: Array[Array] = []
var start: Vector2i = _dimensions / 2

func _ready() -> void:
	_initialize_rooms()
	_create_rooms(start, _number_of_rooms)
	_set_connections()
	_print_level()
	_instantiate_rooms()

func _print_level() -> void:
	"""for debugging"""
	for j in _dimensions.y:
		var to_print = ""
		for i in _dimensions.x:
			if rooms[i][j] == null:
				to_print += "[_] "
			else:
				match rooms[i][j]["type"]:
					0: to_print += "[S] "
					1: to_print += "[H] "
					_: to_print += "[X] "
		print(to_print)
		
	for j in _dimensions.y:
		var to_print = ""
		for i in _dimensions.x:
			if rooms[i][j] == null:
				to_print += "[____] "
			else:
				to_print += "["
				for direction in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
					
					if direction in rooms[i][j]:
						to_print += "T"
					else: 
						to_print += "F"
				to_print += "] "
		print(to_print)
func _initialize_rooms() -> void:
	for i in _dimensions.x:
		rooms.append([])
		for j in _dimensions.y:
			rooms[i].append(null)
	
	rooms[start.x][start.y] = {"type": RoomType.START}

func _create_rooms(current: Vector2i, length: int) -> bool:
	if length == 0:
		return true
	
	var direction: Vector2i
	match randi_range(0, 3):
		0: direction = Vector2i.UP
		1: direction = Vector2i.LEFT
		2: direction = Vector2i.RIGHT
		3: direction = Vector2i.DOWN

	for i in 4:
		if _inbounds(current + direction) and rooms[current.x + direction.x][current.y + direction.y] == null:
			rooms[current.x][current.y][direction] = true
			current += direction
			rooms[current.x][current.y] = {"type": RoomType.NORMAL}
			if _create_rooms(current, length - 1):
				return true
			else:
				# back-track
				rooms[current.x][current.y] = null
				current -= direction
				rooms[current.x][current.y][direction] = false
		direction = Vector2i(direction.y, -direction.x)
	return false

func _inbounds(coord: Vector2i) -> bool:
	if (coord.x >= 0 and coord.x < _dimensions.x and 
		coord.y >= 0 and coord.y < _dimensions.y):
		return true
	else:
		return false

func _set_connections() -> void:
	"""Adds extra connections"""
	for i in _dimensions.x:
		for j in _dimensions.y:
			var possible_directions: Array[Vector2i] = []
			if rooms[i][j] == null: continue
			for direction in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
				if (_inbounds(Vector2i(i + direction.x, j + direction.y)) and 
					rooms[i + direction.x][j + direction.y] != null and 
					direction not in rooms[i][j]):
					possible_directions.append(direction)

			if possible_directions and randi_range(0, 1) == 1:
				var extra_direction: Vector2i = possible_directions[randi_range(0, len(possible_directions) - 1)]
				rooms[i][j][extra_direction] = true
				rooms[i + extra_direction.x][j + extra_direction.y][-extra_direction] = true
				
func _instantiate_rooms() -> void:
	for i in _dimensions.x:
		for j in _dimensions.y:
			if rooms[i][j] == null:
				continue
			var instance
			match rooms[i][j]["type"]:
				RoomType.START: instance = start_room.instantiate()
				RoomType.NORMAL: continue
				RoomType.SPECIAL: continue
				_: continue
				
			instance.position = Vector2i(16 * 16 * i, 16 * 8 * j)
			add_child(instance)
