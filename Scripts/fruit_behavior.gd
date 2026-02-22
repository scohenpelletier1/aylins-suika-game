extends RigidBody2D
signal dropped

@export var next_fruit : PackedScene

var velocity := 10
var was_dropped : bool = false
var fruit_type : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (get_parent().name == "Player"):
		# freeze when first spawned
		freeze = true
	else:
		# if not spawned by player, then it's been "dropped"
		was_dropped = true
	
	# get fruit type and enable collisions
	fruit_type = collision_layer
	contact_monitor = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	pass


func _physics_process(delta: float) -> void:
	if (!was_dropped && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		# make the fruit a child of game view instead of player behavior
		var current_position = Vector2(global_position.x, global_position.y)
		top_level = true
		global_position = current_position
		
		# move it down
		freeze = false
		was_dropped = true
		emit_signal("dropped")	

	
func _on_body_entered(body: RigidBody2D) -> void:
	# only one object can handle the "evolution" of fruits
	if (get_instance_id() > body.get_instance_id()):
		return

	if (was_dropped && body.collision_layer == fruit_type):
		contact_monitor = false
		body.contact_monitor = false

		# if they're watermelons
		if (fruit_type == 13):
			return
		
		# get the new fruit's position
		var fruit_position_x = (global_position.x + body.global_position.x)/2
		var fruit_position_y = (global_position.y + body.global_position.y)/2
		
		var fruit_position = Vector2(fruit_position_x, fruit_position_y)
				
		# create the new fruit
		var fruit_instance = next_fruit.instantiate()
		fruit_instance.global_position = fruit_position
		get_tree().current_scene.add_child(fruit_instance)
		
		# delete current fruits
		body.queue_free()
		queue_free()
