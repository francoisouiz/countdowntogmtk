extends CharacterBody2D


@export var SPEED = 150.0

func move_player() -> void:
	var vertical_direction := Input.get_axis("move_up_key", "move_down_key")
	if vertical_direction:
		velocity.y = vertical_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	var horizontal_direction := Input.get_axis("move_left_key", "move_right_key")
	if horizontal_direction:
		velocity.x = horizontal_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func _process(delta: float) -> void:
	move_player()
