extends Node2D
class_name Level

@export var _dimensions: Vector2i = Vector2i(7, 5)
@export var _number_of_rooms: int = 10

@onready var room_scene = preload("res://scenes/room.tscn")
@onready var level_root = %LevelRoot

var rooms: Array[Array] = []
var start: Vector2i = _dimensions / 2

func _ready() -> void:
	_initialize_rooms()
	_create_rooms(start, _number_of_rooms)
	_set_connections()
	_print_level()

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

func _initialize_rooms() -> void:
	for i in _dimensions.x:
		rooms.append([])
		for j in _dimensions.y:
			rooms[i].append(null)
	
	rooms[start.x][start.y] = {"type": 0}

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
		if _check_coord(current + direction):
			current += direction
			rooms[current.x][current.y] = {"type": 1}
			if _create_rooms(current, length - 1):
				return true
			else:
				# back-track
				rooms[current.x][current.y] = null
				current -= direction
		direction = Vector2i(direction.y, -direction.x)
	return false

func _check_coord(coord: Vector2i) -> bool:
	if (coord.x >= 0 and coord.x < _dimensions.x and 
		coord.y >= 0 and coord.y < _dimensions.y and 
		rooms[coord.x][coord.y] == null):
		return true
	else:
		return false
	

func _set_connections() -> void:
	pass
