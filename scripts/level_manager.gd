extends Node

@onready var level = preload("res://scenes/level.tscn")
@onready var root = get_parent()
@onready var level_number: int = 1

func _ready() -> void:
	Events.level_cleared.connect(func(level):
		level_number += 1
		level.queue_free()
		create_level()
	)

func create_level() -> void:
	var level_instance = level.instantiate()
	level_instance.level_number = level_number
	root.call_deferred("add_child", level_instance)
	
