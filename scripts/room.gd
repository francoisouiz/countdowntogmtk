extends Node2D
class_name Room

@onready var door_up = %DoorUp
@onready var door_down = %DoorDown
@onready var door_left = %DoorLeft
@onready var door_right = %DoorRight
@onready var room_area = %RoomArea
@onready var doors = [door_up, door_down, door_left, door_right]

const DIMENSIONS: Vector2i = Vector2i(9, 9) # in tiles
var locked: bool = false # is the room locked within?
var cleared: bool = false # is the room cleared?
var door_directions = {Vector2i.UP: false, Vector2i.DOWN: false, Vector2i.LEFT: false, Vector2i.RIGHT: false}

func _ready() -> void:
	add_to_group("room")
	
	door_up.direction = Vector2i.UP
	door_down.direction = Vector2i.DOWN
	door_left.direction = Vector2i.LEFT
	door_right.direction = Vector2i.RIGHT
	
	if !door_directions[Vector2i.UP]: door_up.disable()
	if !door_directions[Vector2i.DOWN]: door_down.disable()
	if !door_directions[Vector2i.LEFT]: door_left.disable()
	if !door_directions[Vector2i.RIGHT]: door_right.disable()
	
	unlock()
	visible = false

func lock() -> void:
	locked = true
	
	for door in doors:
		door.lock()
		
func unlock() -> void:
	locked = false
	
	for door in doors:
		door.unlock()
		
func clear() -> void:
	if cleared:
		pass
	print("cleared")
	
	cleared = true
	Events.room_cleared.emit(self)

func _on_room_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		visible = true
		Events.room_entered.emit(self)
