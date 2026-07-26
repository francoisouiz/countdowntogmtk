extends Control

@onready var countdown_label: Label = $HBoxContainer/MarginContainer/CountdownLabel

func _process(delta):
	var enemies = get_tree().get_nodes_in_group("enemies")
	countdown_label.text = str(len(enemies))
