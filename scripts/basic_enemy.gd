extends CharacterBody2D
class_name Enemy

@onready var shooting_cooldown: Timer = $ShootingCooldown
@onready var player: CharacterBody2D = get_node("%Player")

var SPEED = 50.0

func move(delta) -> void:
	if player:
		var components = (player.position-position).normalized()
		
		velocity = SPEED * components
		move_and_slide()

func die() -> void:
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)
	pass
