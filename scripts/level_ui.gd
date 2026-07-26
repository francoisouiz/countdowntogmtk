extends Control

func _ready() -> void:
	var player = get_node("/root/Root/Level/Player")
	Events.player_died.connect(_on_player_death)

func _on_player_death(player) -> void:
	var game_over_ui = load("res://scenes/menu_uis/game_over_ui.tscn").instantiate()
	add_child(game_over_ui)
