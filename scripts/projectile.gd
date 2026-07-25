extends Node2D
class_name Projectile

@onready var despawn_timer: Timer = $DespawnTimer

const SPEED = 300
var _velocity_components = Vector2(0.0,0.0)

func set_velocity_components(components: Vector2):
	_velocity_components = components

func move(delta: float):
	position += _velocity_components * (SPEED*delta)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	despawn_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)

func _on_despawn_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.die()
		queue_free()
