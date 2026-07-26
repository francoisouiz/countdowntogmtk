extends Control

@onready var level_manager:  = get_node("/root/Root/LevelManager")

func _on_return_button_click() -> void:
	var main_menu = load("res://scenes/menu_uis/main_menu_ui.tscn").instantiate()
	var canvas_layer = get_node("/root/Root/UI")
	canvas_layer.add_child(main_menu)

	get_node("/root/Root/Level").queue_free()
	PlayerStats.health_time = 20.0
	canvas_layer.get_node("Level_UI").queue_free()
