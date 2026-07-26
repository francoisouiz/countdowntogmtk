extends Node

@onready var room: Room = get_parent()
@onready var cells: Array[Vector2i] = room.get_node("Ground").get_used_cells()
@onready var basic_enemy = preload("res://scenes/basic_enemy.tscn")

@export var number_of_enemies: int = 3

func _process(delta: float) -> void:
	check_all_dead()

func _on_room_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		room.lock()
		_spawn_enemies()
		
	
func _spawn_enemies():
	var instance : BasicEnemy
	var rand_pos : Vector2i
	var taken : Dictionary[Vector2i, bool]
	
	for i in number_of_enemies:
		instance = basic_enemy.instantiate()
		while true:
			rand_pos = cells[randi() % cells.size()]
			if rand_pos not in taken:
				taken[rand_pos] = true
				break
		instance.position = Vector2(rand_pos) * 16 + Vector2(8, 8)
		instance.z_index = 10
		room.call_deferred("add_child", instance)
	
	
func check_all_dead():
	var stop = true
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.get_parent() == room:
			stop = false
			break
	if stop:
		room.unlock()
	
	
	
