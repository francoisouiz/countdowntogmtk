extends Node

@onready var room: Room = get_parent()
@onready var cells: Array[Vector2i] = room.get_node("Ground").get_used_cells()
@onready var basic_enemy = preload("res://scenes/basic_enemy.tscn")

@onready var number_of_enemies: int = randi_range(3, 5)
@onready var number_of_enemies_died: int = 0

func _ready() -> void:
	Events.enemy_died.connect(func(enemy):
		if enemy.get_parent() == get_parent():
			number_of_enemies_died += 1
			if number_of_enemies_died == number_of_enemies:
				room.unlock()
				room.clear()
	)

func _on_room_area_body_entered(body: Node2D) -> void:
	if room.cleared:
		return
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
