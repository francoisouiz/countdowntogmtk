extends Control

@onready var countdown_label: Label = $HBoxContainer/MarginContainer/CountdownLabel

func _process(delta):
	var enemies = get_tree().get_node_count_in_group("enemy")
	countdown_label.text = str(enemies)
