extends CharacterBody2D
@export var speed = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position.x = 960
	global_position.y = 91

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x = get_global_mouse_position().x
