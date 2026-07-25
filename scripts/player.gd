extends CharacterBody2D

enum Vampire_Forms {HUMAN, BAT}

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var current_form: Vampire_Forms = Vampire_Forms.HUMAN
@export var SPEED: float = 150.0

func _ready() -> void:
	add_to_group("player")
	if RoomChangeGlobal.activate:
		global_position = RoomChangeGlobal.player_pos
		RoomChangeGlobal.activate = false

func move_player() -> void:
	var vertical_direction = Input.get_axis("move_up_key", "move_down_key")
	if vertical_direction:
		velocity.y = vertical_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	var horizontal_direction = Input.get_axis("move_left_key", "move_right_key")
	if horizontal_direction:
		velocity.x = horizontal_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func shoot() -> void:
	if Input.is_action_just_pressed("shoot"):
		var mouse_coordinates: Vector2 = get_global_mouse_position()
		print(mouse_coordinates.x, mouse_coordinates.y)
		print("click")

func switch_form() -> void:
	if Input.is_action_just_pressed("switch_form_key"):
		if current_form == Vampire_Forms.HUMAN:
			current_form = Vampire_Forms.BAT
			animated_sprite.play("fly")
			
		elif current_form == Vampire_Forms.BAT:
			current_form = Vampire_Forms.HUMAN
			animated_sprite.play("idle")

func _process(delta: float) -> void:
	switch_form()
	if current_form == Vampire_Forms.HUMAN:
		shoot()
	elif current_form == Vampire_Forms.BAT:
		move_player()
