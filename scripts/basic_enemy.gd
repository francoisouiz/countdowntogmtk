extends CharacterBody2D
class_name BasicEnemy

var player: Player
var found_player = false
var blood_drop_scene = preload("res://scenes/blood_drop.tscn")
var _touching_player = false

@export var damage = 10.0
var SPEED = 30.0

func _ready() -> void:
	add_to_group("enemy")

func move(delta) -> void:
	if player:
		var components = (player.global_position-global_position).normalized()
		
		velocity = SPEED * components
		move_and_slide()

func die() -> void:
	var drop = blood_drop_scene.instantiate()
	drop.position = global_position
	get_node("../../BloodDrops").call_deferred("add_child", drop)
	
	Events.enemy_died.emit(self)
	print("dead")
	
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not found_player and not player:
		# repeatedly tries to find the player. Once it finds it, it will stop looking
		player = get_node("../../Player")
		found_player = true
		pass
	move(delta)
	damage_player()
	pass

func damage_player() -> void:
	if _touching_player:
		player.take_damage(damage)

func _on_body_entered(body: Node2D) -> void:
	if body in get_tree().get_nodes_in_group("player"):
		_touching_player = true

func _on_body_exited(body: Node2D) -> void:
	if body in get_tree().get_nodes_in_group("player"):
		_touching_player = false
