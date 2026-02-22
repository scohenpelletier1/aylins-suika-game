# NOT SURE IF SCRIPT IS NEEDED RIGHT NOW

extends Node2D

var score : int = 0
var fruit_dropped : bool = false
var playing : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_points(points: int):
	score += points
