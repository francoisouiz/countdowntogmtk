extends Node2D

const DIMENSIONS: Vector2i = Vector2i(7, 5)

@export var _number_of_rooms: int = 10

@onready var start_room = preload("res://scenes/rooms/start_room.tscn")
@onready var normal_room = preload("res://scenes/rooms/normal_room.tscn")
@onready var player = preload("res://scenes/player.tscn")

enum RoomType { START, NORMAL, SPECIAL }

var rooms: Array[Array] = []
var start: Vector2i = DIMENSIONS / 2

func _ready() -> void:
	_initialize_rooms()
	_create_rooms(start, _number_of_rooms)
	_set_connections()
	_print_level()
	_instantiate_rooms()

func _print_level() -> void:
	"""for debugging"""
	for j in DIMENSIONS.y:
		var to_print = ""
		for i in DIMENSIONS.x:
			if rooms[i][j] == null:
				to_print += "[_] "
			else:
				match rooms[i][j]["type"]:
					0: to_print += "[S] "
					1: to_print += "[H] "
					_: to_print += "[X] "
		print(to_print)
		
	for j in DIMENSIONS.y:
		var to_print = ""
		for i in DIMENSIONS.x:
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
	for i in DIMENSIONS.x:
		rooms.append([])
		for j in DIMENSIONS.y:
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
			rooms[current.x][current.y][-direction] = true
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
	if (coord.x >= 0 and coord.x < DIMENSIONS.x and 
		coord.y >= 0 and coord.y < DIMENSIONS.y):
		return true
	else:
		return false

func _set_connections() -> void:
	"""Adds extra connections"""
	for i in DIMENSIONS.x:
		for j in DIMENSIONS.y:
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
	for i in DIMENSIONS.x:
		for j in DIMENSIONS.y:
			if rooms[i][j] == null:
				continue
			var room_instance
			var player_instance
			match rooms[i][j]["type"]:
				RoomType.START: 
					room_instance = start_room.instantiate()
					player_instance = player.instantiate()
					player_instance.position = (Vector2(11 * i, 11 * j) + Vector2(Room.DIMENSIONS) / 2) * 16
					player_instance.z_index = 10
					
				RoomType.NORMAL: room_instance = normal_room.instantiate()
				RoomType.SPECIAL: continue
				_: continue
			
			for direction in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
				if direction in rooms[i][j]:
					room_instance.door_directions[direction] = rooms[i][j][direction]
			
			room_instance.position = Vector2i(16 * 11 * i, 16 * 11 * j)
			add_child(room_instance)
			if rooms[i][j]["type"] == RoomType.START:
				add_child(player_instance)
