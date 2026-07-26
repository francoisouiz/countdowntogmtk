extends CharacterBody2D
class_name Player

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
@export var can_shoot = true

var can_take_damage = true
var diff_sec = 0
var curr_vel = Vector2()
var press_time = 0
var final_mouse = Vector2()
var final_pos = Vector2()


var projectile_scene = preload("res://scenes/projectile.tscn")

func _ready() -> void:
	add_to_group("player")
	
	inven = PlayerStats.inventory
	health_timer.wait_time = PlayerStats.health_time
	health_timer.start()
	
	Events.level_cleared.connect(func(level):
		PlayerStats.health_time = health_timer.time_left
		PlayerStats.inventory = inven
	)
	
	Events.room_entered.connect(func(room):
		curr_vel = Vector2()
	)
	Events.room_entered.connect(func(level):
		can_take_damage = false
		i_frame_cooldown.start()
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
		if velocity.length() < 100:
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
		
func _on_enter_timeout():
	curr_vel = Vector2()
		
		
		
func ded():
	Events.player_died.emit(self)
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
		if diff_sec > 0.3:
			diff_sec = 0.3
		final_pos = global_position
		final_mouse = get_global_mouse_position()
		curr_vel = final_mouse - final_pos

func get_relative_mouse_position() -> Vector2:
	var mouse_coordinates: Vector2 = get_global_mouse_position()
	return Vector2(mouse_coordinates.x - position.x, mouse_coordinates.y - position.y)

func shoot() -> void:
	if !can_shoot or !get_node("../PlayerProjectiles"):
		return
	if Input.is_action_just_pressed("shoot"):
		var rand = randi_range(1, 3)
		match rand:
			1:
				%Shoot.play()
			2:
				%Shoot2.play()
			3:
				%Shoot3.play()
		var mouse_coordinates: Vector2 = get_relative_mouse_position().normalized()
		
		if "trip" not in inven:
			var proj = projectile_scene.instantiate()
			
			proj.set_velocity_components(mouse_coordinates)
			proj.position = position
			
			get_node("../PlayerProjectiles").add_child(proj)
		else:
			var proj1 = projectile_scene.instantiate()
			var proj2 = projectile_scene.instantiate()
			var proj3 = projectile_scene.instantiate()
			
			proj1.set_velocity_components(mouse_coordinates)
			proj2.set_velocity_components(mouse_coordinates.rotated(PI/6))
			proj3.set_velocity_components(mouse_coordinates.rotated(-PI/6))
			proj1.position = position
			proj2.position = position
			proj3.position = position
			
			get_node("../PlayerProjectiles").add_child(proj1)
			get_node("../PlayerProjectiles").add_child(proj2)
			get_node("../PlayerProjectiles").add_child(proj3)

func _on_i_frame_cooldown_timeout() -> void:
	can_take_damage = true

func _on_animation_finished(anim_name: StringName) -> void:
	#implies one of the transforms ended
	if anim_name == "transform_to_bat":
		animation_player.play("fly")
	elif anim_name == "transform_to_human":
		animation_player.play("idle")
