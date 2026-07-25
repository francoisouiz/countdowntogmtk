extends Area2D
class_name Door

@export var direction: Vector2i

var disabled: bool = false
var locked: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !locked and !disabled:
		body.global_position += Vector2(direction) * 64

func disable() -> void:
	disabled = true
	visible = false
