extends Node2D


@export var heal_value: int = 20

#@onready var player: CharacterBody2D = get_node("%Player")

func pickup(player: Node2D) -> void:
	player.add_time(heal_value)
	queue_free()
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		pickup(body)
