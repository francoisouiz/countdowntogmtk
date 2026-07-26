extends CharacterBody2D
class_name Player

signal player_died
signal human

enum Vampire_Forms {HUMAN, BAT}
var inven = []

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_timer: Timer = get_node("/root/Root/PlayerStats/HealthTimer")
@onready var i_frame_cooldown: Timer = $IFrameCooldown
#@export var max_health_time: float = 20.0
@export var current_form: Vampire_Forms = Vampire_Forms.HUMAN
@export var speed = 1500

var can_take_damage = true
var diff_sec = 0
var curr_vel = Vector2()
var press_time = 0
var final_mouse = Vector2()
var final_pos = Vector2()

var projectile_scene = preload("res://scenes/projectile.tscn")

func _ready() -> void:
	add_to_group("player")

	health_timer.wait_time = PlayerStats.health_time
	health_timer.start()
	
	Events.level_cleared.connect(func(level):
		PlayerStats.health_time = health_timer.time_left
	)


func _physics_process(delta):	
	if current_form == Vampire_Forms.HUMAN:
		shoot()
		set_collision_mask_value(2, true)
	else:
		set_collision_mask_value(2, false)
	if diff_sec == 0:
		current_form = Vampire_Forms.HUMAN
	if velocity != Vector2():
		animation_player.play("transform_to_human")
		human.emit()
	if health_timer.time_left <= 0:
		ded()
	velocity = curr_vel.normalized() * diff_sec * speed
	diff_sec = move_toward(diff_sec, 0.0, 0.8 * delta)
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		if "bounce" in inven:
			curr_vel = curr_vel.bounce(collision_info.get_normal())
		else:
			move_and_slide()
	
	if get_relative_mouse_position().x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
	
func take_damage(hp):
	if can_take_damage:
		var current_left = health_timer.time_left
		var new_time = max(0.0, current_left - hp)
		
		if new_time > 0:
			health_timer.start(new_time)
		else:
			health_timer.stop()
			ded()
		
		can_take_damage = false
		i_frame_cooldown.start()
		
		
func ded():
	player_died.emit()
	queue_free()
		
func add_time(hp):
	var current_left = health_timer.time_left
	health_timer.start(current_left + hp)

func _input(event):
	if event.is_action_pressed("charge"):
		animation_player.play("transform_to_bat")
		press_time = Time.get_ticks_msec()
	
	elif event.is_action_released("charge"):
		var release_time = Time.get_ticks_msec()
		var diff_ms = release_time - press_time
		current_form = Vampire_Forms.BAT
		diff_sec = diff_ms / 1500.0
		final_pos = global_position
		final_mouse = get_global_mouse_position()
		curr_vel = final_mouse - final_pos

func get_relative_mouse_position() -> Vector2:
	var mouse_coordinates: Vector2 = get_global_mouse_position()
	return Vector2(mouse_coordinates.x - position.x, mouse_coordinates.y - position.y)

func shoot() -> void:
	if Input.is_action_just_pressed("shoot"):
		var mouse_coordinates: Vector2 = get_relative_mouse_position().normalized()
		var proj = projectile_scene.instantiate()
		
		proj.set_velocity_components(mouse_coordinates)
		proj.position = position
		
		get_node("../PlayerProjectiles").add_child(proj)

func _on_i_frame_cooldown_timeout() -> void:
	can_take_damage = true

func _on_animation_finished(anim_name: StringName) -> void:
	#implies one of the transforms ended
	if anim_name == "transform_to_bat":
		animation_player.play("fly")
	elif  anim_name == "transform_to_human":
		animation_player.play("idle")
