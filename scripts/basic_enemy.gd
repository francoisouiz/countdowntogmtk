extends CharacterBody2D
class_name Enemy

var player: Player
var blood_drop_scene = preload("res://scenes/blood_drop.tscn")
var _can_damage = false

@export var damage = 10.0
var SPEED = 30.0

func move(delta) -> void:
	if player:
		var components = (player.position-position).normalized()
		
		velocity = SPEED * components
		move_and_slide()

func die() -> void:
	var drop = blood_drop_scene.instantiate()
	drop.position = position
	get_node("/root/Root/BloodDrops").call_deferred("add_child", drop)
	
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not player:
		player = get_node("../Player")
		pass
	move(delta)
	damage_player()
	pass

func damage_player() -> void:
	if _can_damage:
		player.take_damage(damage)

func _on_body_entered(body: Node2D) -> void:
	if body in get_tree().get_nodes_in_group("player"):
		_can_damage = true

func _on_body_exited(body: Node2D) -> void:
	if body in get_tree().get_nodes_in_group("player"):
		_can_damage = false
