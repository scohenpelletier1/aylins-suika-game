extends CharacterBody2D
var speed := Vector2(0, 0)
var fruit_choice := RandomNumberGenerator.new()
var current_fruit : int
var next_fruit : int

@export var fruits: Array[PackedScene] = [
	preload("res://Sprites/cherry.tscn"),
	preload("res://Sprites/strawberry.tscn"),
	preload("res://Sprites/grape.tscn"),
	preload("res://Sprites/dekopan.tscn"),
	preload("res://Sprites/persimmon.tscn")]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	# starting position for the player
	global_position.x = 960
	global_position.y = 91
	
	# first fruits generated
	current_fruit = fruit_choice.randi_range(0, 4)
	next_fruit = fruit_choice.randi_range(0, 4)
	
	# start spawining fruits
	spawn_fruits()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var target_x = get_global_mouse_position().x
	velocity = Vector2((target_x - global_position.x) / delta, 0)
	move_and_slide()

func spawn_fruits():
	# create the fruit
	var fruit_instance = fruits[current_fruit].instantiate()
	fruit_instance.position = Vector2(3, 60)
	
	add_child(fruit_instance)
		
	# wait 2 seconds for next fruit
	await get_tree().create_timer(2).timeout
	
	# get the new fruits
	current_fruit = next_fruit
	next_fruit = fruit_choice.randi_range(0, 4)
