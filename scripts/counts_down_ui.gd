extends Control

@onready var countdown_label: Label = $HBoxContainer/MarginContainer/CountdownLabel
var counter = 0

func _ready() -> void:
	Events.enemy_died.connect(_incrament)

func _incrament(enemy):
	counter += 1
	countdown_label.text = str(counter)
