extends Node2D
class_name Room

const DIMENSIONS: Vector2i = Vector2i(16, 8) # in tiles
var locked: bool = false # is the room locked within?
