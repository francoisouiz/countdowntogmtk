extends Control

@onready var timer: Timer = $Timer

func _on_timer_timeout() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	
	if (event.is_action_pressed("charge")
		or event.is_action_pressed("shoot")):
		get_node("Label3").visible = false
