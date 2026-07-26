extends Control

@onready var label = get_node("MarginContainer/HBoxContainer/MarginContainer/Label")
@onready var timer = get_node("/root/Root/Level/Player/Timer")

func _process(delta):
	if timer:
		label.text = str(int(timer.time_left))
	 

	
