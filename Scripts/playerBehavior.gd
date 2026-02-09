extends CharacterBody2D
var speed := Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# starting position for the player
	global_position.x = 960
	global_position.y = 91

func _physics_process(delta: float) -> void:
	var target_x = get_global_mouse_position().x
	velocity = Vector2((target_x - global_position.x) / delta, 0)
	move_and_slide()
