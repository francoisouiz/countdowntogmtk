extends Control

func _on_play_button_click() -> void:
	var level = load("res://scenes/level.tscn").instantiate()
	var game_ui = load("res://scenes/menu_uis/level_ui.tscn").instantiate()
	
	get_node("/root/Root").add_child(level)
	get_node("/root/Root/CanvasLayer").add_child(game_ui)
	
	queue_free()
