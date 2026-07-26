extends Node2D

@onready var l1 = $CanvasLayer/Label
var master_bus = AudioServer.get_bus_index("Master")

func _ready():
	AudioServer.set_bus_mute(master_bus, true)
	await get_tree().create_timer(4.0).timeout
	l1.text = "Your family, your friends"
	await get_tree().create_timer(4.0).timeout
	l1.text = "You killed everyone you knew"
	await get_tree().create_timer(4.0).timeout
	l1.text = "All to delay your inevitable death"
	await get_tree().create_timer(4.0).timeout
	l1.text = "With no blood to feast on, there is nothing left"
	await get_tree().create_timer(4.0).timeout
	l1.text = "You may only wait your time out and bleed to death"
	await get_tree().create_timer(4.0).timeout
	l1.text = "A fitting end for a monster like you"
	await get_tree().create_timer(4.0).timeout
	l1.hide()
	get_tree().quit()
