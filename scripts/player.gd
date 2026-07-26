extends CharacterBody2D
class_name Player

enum Vampire_Forms {HUMAN, BAT}

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_timer: Timer = $Timer
@onready var i_frame_cooldown: Timer = $IFrameCooldown
@export var max_health_time: float = 150
@export var current_form: Vampire_Forms = Vampire_Forms.HUMAN
@export var speed = 3000

var diff_sec = 0
var press_time = 0
var final_mouse = Vector2()
var final_pos = Vector2()

var projectile_scene = preload("res://scenes/projectile.tscn")

func _ready() -> void:
	add_to_group("player")
	if RoomChangeGlobal.activate:
		global_position = RoomChangeGlobal.player_pos
		RoomChangeGlobal.activate = false

	health_timer.wait_time = max_health_time
	health_timer.start()


func _physics_process(delta):
	if current_form == Vampire_Forms.HUMAN:
		shoot()
	if diff_sec == 0:
		current_form = Vampire_Forms.HUMAN
		look_at(get_global_mouse_position())
	if health_timer.time_left <= 0:
		ded()
	velocity = (final_mouse - final_pos).normalized() * diff_sec * speed
	diff_sec = move_toward(diff_sec, 0.0, 0.8 * delta)
	move_and_slide()
	
func take_damage(hp):
	if i_frame_cooldown.is_stopped():
		var current_left = health_timer.time_left
		var new_time = max(0.0, current_left - hp)
		
		if new_time > 0:
			health_timer.start(new_time)
		else:
			health_timer.stop()
			ded()
		
		i_frame_cooldown.start()
		
		
func ded():
	queue_free()
		
func add_time(hp):
	var current_left = health_timer.time_left
	health_timer.start(current_left + hp)

func _input(event):
	if event.is_action_pressed("charge"):
		press_time = Time.get_ticks_msec()
	elif event.is_action_released("charge"):
		var release_time = Time.get_ticks_msec()
		var diff_ms = release_time - press_time
		current_form = Vampire_Forms.BAT
		diff_sec = diff_ms / 1000.0
		final_pos = global_position
		final_mouse = get_global_mouse_position()

func get_relative_mouse_position() -> Vector2:
	var mouse_coordinates: Vector2 = get_global_mouse_position()
	return Vector2(mouse_coordinates.x - position.x, mouse_coordinates.y - position.y)

func shoot() -> void:
	if Input.is_action_just_pressed("shoot"):
		var mouse_coordinates: Vector2 = get_relative_mouse_position().normalized()
		var proj = projectile_scene.instantiate()
		
		proj.set_velocity_components(mouse_coordinates)
		proj.position = position
		
		get_node("/root/Root/PlayerProjectiles").add_child(proj)
