extends Node2D

func pickup(player: Node2D) -> void:
	player.inven.append("trip")
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		pickup(body)
