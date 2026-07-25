extends AnimatableBody2D
class_name Enemy

@onready var shooting_cooldown: Timer = $ShootingCooldown

var projectile_scene = preload("res://scenes/projectile.tscn")

func shoot() -> void:
	var proj = projectile_scene.instantiate()
	proj.set_velocity_components(Vector2(-1, 0))
	proj.position = position
	
	get_node("/root/Root/EnemyProjectiles").add_child(proj)
	
	shooting_cooldown.start()

func die() -> void:
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shooting_cooldown.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_shooting_cooldown_timeout() -> void:
	pass
	#shoot()
