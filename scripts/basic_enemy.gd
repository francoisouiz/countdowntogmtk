extends CharacterBody2D
class_name Enemy

@onready var player: CharacterBody2D = get_node("%Player")

var SPEED = 30.0

func move(delta) -> void:
	if player:
		var components = (player.position-position).normalized()
		
		velocity = SPEED * components
		move_and_slide()

func die() -> void:
	queue_free()

func kill(player_node: Node2D) -> void:
	player_node.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)
	pass

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		print("die")
		kill(body)
