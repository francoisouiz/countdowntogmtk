extends Node

@onready var level = preload("res://scenes/level.tscn")
@onready var player = preload("res://scenes/player.tscn")
@onready var end_room = preload("res://scenes/rooms/end_room.tscn")
@onready var root = get_parent()
@onready var UI = root.get_node("UI")
@onready var level_number: int = 1

var enemy_count = 0

func _ready() -> void:
	Events.level_cleared.connect(func(level):
		level_number += 1
		level.queue_free()
		if level_number == 2:
			load_end_scene()
		else:
			create_level()
	)

func get_enemy_count() -> int:
	return get_tree().get_node_count_in_group("enemy")

func create_level() -> void:
	var level_instance = level.instantiate()
	level_instance.level_number = level_number
	root.call_deferred("add_child", level_instance)

	enemy_count = get_enemy_count()

func load_end_scene() -> void:
	var room = end_room.instantiate()
	root.call_deferred("add_child", room)
