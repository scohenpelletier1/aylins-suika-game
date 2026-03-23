extends Button

var score : int = 0
var fruit_dropped : bool = false
var playing : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(start_reset)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func start_reset():
	GameManager.reset_game()


func add_points(points: int):
	score += points
