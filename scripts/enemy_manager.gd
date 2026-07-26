extends Node

signal enemy_died

func _on_new_enemy(node: Node) -> void:
	node.enemy_died.connect(_on_enemy_death)

func _on_enemy_death():
	enemy_died.emit()
