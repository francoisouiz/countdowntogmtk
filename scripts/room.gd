extends Node2D
class_name Room

const DIMENSIONS: Vector2i = Vector2i(9, 9) # in tiles
var locked: bool = false # is the room locked within?

@onready var door_up = %DoorUp
@onready var door_down = %DoorDown
@onready var door_left = %DoorLeft
@onready var door_right = %DoorRight
@onready var room_area = %RoomArea

var door_directions = {Vector2i.UP: false, Vector2i.DOWN: false, Vector2i.LEFT: false, Vector2i.RIGHT: false}

func _ready() -> void:
	door_up.direction = Vector2i.UP
	door_down.direction = Vector2i.DOWN
	door_left.direction = Vector2i.LEFT
	door_right.direction = Vector2i.RIGHT
	
	if !door_directions[Vector2i.UP]: door_up.disable()
	if !door_directions[Vector2i.DOWN]: door_down.disable()
	if !door_directions[Vector2i.LEFT]: door_left.disable()
	if !door_directions[Vector2i.RIGHT]: door_right.disable()

func _on_room_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Events.room_entered.emit(self)
