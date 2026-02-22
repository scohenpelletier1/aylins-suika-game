extends RigidBody2D
signal dropped

var velocity := 10
var was_dropped : bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# freeze when first spawned
	freeze = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if (!GameManager.fruit_dropped):
		if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
			# make the fruit a child of game view instead of player behavior
			var current_position = Vector2(global_position.x, global_position.y)
			top_level = true
			position = current_position
			
			# move it down
			freeze = false
			emit_signal("dropped")
