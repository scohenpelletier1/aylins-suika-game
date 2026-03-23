<<<<<<<< HEAD:Scenes/game_manager.gd
# NOT SURE IF SCRIPT IS NEEDED RIGHT NOW
========
extends Button
>>>>>>>> origin/main:Scripts/button.gd

extends Node2D

var score : int = 0
var fruit_dropped : bool = false
var playing : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(start_reset)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


<<<<<<<< HEAD:Scenes/game_manager.gd
func add_points(points: int):
	score += points
========
func start_reset():
	GameManager.reset_game()
>>>>>>>> origin/main:Scripts/button.gd
