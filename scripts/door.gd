extends Area2D

@export var connected_room: String

@export var direction: Vector2i

var locked: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !locked:
		RoomChangeGlobal.activate = true
		RoomChangeGlobal.player_pos = position + Vector2(direction)
