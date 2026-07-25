extends Area2D

@export var direction: Vector2i

var disabled: bool = false
var locked: bool = false

func _ready() -> void:
	if disabled:
		visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !locked and !disabled:
		RoomChangeGlobal.activate = true
		RoomChangeGlobal.player_pos = position + Vector2(direction)
