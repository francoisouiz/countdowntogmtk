extends Camera2D

func _ready() -> void:
	#global_position = (Vector2(11 * get_parent().DIMENSIONS.x, 11 * get_parent().DIMENSIONS.x) / 2) * 16
	
	Events.room_entered.connect(func(room):
		global_position = room.global_position + (Vector2(room.DIMENSIONS) + Vector2(1, 1)) * 8
	)
