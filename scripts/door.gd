extends Area2D
class_name Door

@export var direction: Vector2i

var disabled: bool = false
var locked: bool = false
var door_texture = null

func _ready() -> void:
	var door_texture_bundle = get_node("DoorTexture")
	if door_texture_bundle:
		door_texture = door_texture_bundle.get_node("Door")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !locked and !disabled:
		body.global_position += Vector2(direction) * 64

func disable() -> void:
	disabled = true
	visible = false

func unlock() -> void:
	$Unlock.play()
	door_texture.visible = false
	locked = false
	
func lock() -> void:
	$Lock.play()
	door_texture.visible = true
	locked = true
