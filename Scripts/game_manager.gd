extends Node2D

# manager variables
var score : int = 0
var fruit_dropped : bool = false
var playing : bool = true

# ui variables
var current_score : Label
var best_score : Label

# eported variables
@export var fruits: Array[Texture2D] = [
	preload("res://Art/cherry.png"),
	preload("res://Art/strawberry.png"),
	preload("res://Art/grape.png"),
	preload("res://Art/dekopan.png"),
	preload("res://Art/persimmon.png")]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# get the current and best score variables
	current_score = get_tree().current_scene.get_node("CanvasLayer").get_child(2)
	best_score = get_tree().current_scene.get_node("CanvasLayer").get_child(2)
	
	# set the current score to 0
	current_score.text = "0"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_points(points: int):
	score += points
	current_score.text = str(score)


func update_next(fruit_type: int):
	var next_fruit : Sprite2D = get_tree().current_scene.get_node("CanvasLayer").get_child(0)
	var new_texture : Texture2D = fruits[fruit_type]
	
	next_fruit.texture = new_texture
	
	# set the scales
	if (fruit_type == 0):
		next_fruit.scale = Vector2(0.71, 0.71)
		next_fruit.position = Vector2(1545.0, 270.0)
	else: if (fruit_type == 1):
		next_fruit.scale = Vector2(0.70, 0.70)
		next_fruit.position = Vector2(1540.0, 275.0)
	else: if (fruit_type == 2):
		next_fruit.scale = Vector2(0.71, 0.71)
		next_fruit.position = Vector2(1536.0, 271.0)
	else: if (fruit_type == 3):
		next_fruit.scale = Vector2(0.74, 0.74)
		next_fruit.position = Vector2(1544.0, 270.0)
	else:
		next_fruit.scale = Vector2(0.72, 0.72)
		next_fruit.position = Vector2(1546.0, 272.0)
