extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(start_reset)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func start_reset():
	GameManager.reset_game()
