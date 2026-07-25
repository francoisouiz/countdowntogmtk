extends CharacterBody2D

@export var speed = 3000
var diff_sec = 0
var press_time = 0
var final_mouse = Vector2()
var final_pos = Vector2()

func _physics_process(delta):
	if diff_sec == 0:
		look_at(get_global_mouse_position())
	velocity = (final_mouse - final_pos).normalized() * diff_sec * speed
	diff_sec = move_toward(diff_sec, 0.0, 0.8 * delta)
	print(diff_sec)
	move_and_slide()

func _input(event):
	if event.is_action_pressed("charge"):
		press_time = Time.get_ticks_msec()
	elif event.is_action_released("charge"):
		var release_time = Time.get_ticks_msec()
		var diff_ms = release_time - press_time
		diff_sec = diff_ms / 1000.0
		final_pos = global_position
		final_mouse = get_global_mouse_position()
