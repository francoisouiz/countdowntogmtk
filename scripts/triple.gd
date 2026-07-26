extends Node2D

@onready var label = $CanvasLayer/Label
@onready var sprite = $Sprite2D
@onready var coll = $Area2D/CollisionShape2D
@onready var sound = $Pickup
@onready var timer = $Timer

func _ready():
	label.hide()

func pickup(player: Node2D) -> void:
	sprite.hide()
	coll.set_deferred("disabled", true)
	label.show()
	sound.play()
	player.inven.append("trip")
	timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		pickup(body)

func _on_timer_timeout() -> void:
	queue_free()
