extends RigidBody2D
<<<<<<< HEAD

# signals
=======
<<<<<<< HEAD
>>>>>>> origin/Fruit-Behavior
signal dropped

# exported variables
@export var next_fruit : PackedScene

# instance variables
var velocity : Vector2
var was_dropped : bool = false
var fruit_type : int
var is_dragging : bool = false
var drag_offset : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
<<<<<<< HEAD
	input_pickable = true
	
=======
=======

# signals
signal dropped

# exported variables
@export var next_fruit : PackedScene

# instance variables
var velocity : Vector2
var was_dropped : bool = false
var fruit_type : int
var is_dragging : bool = false
var drag_offset : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_pickable = true
	
>>>>>>> origin/main
>>>>>>> origin/Fruit-Behavior
	if (get_parent().name == "Player"):
		# freeze when first spawned
		freeze = true
	else:
<<<<<<< HEAD
=======
<<<<<<< HEAD
		# if not spawned by player, then it's been "dropped"
=======
>>>>>>> origin/main
>>>>>>> origin/Fruit-Behavior
		was_dropped = true
	
	# get fruit type and enable collisions
	fruit_type = collision_layer
	contact_monitor = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
<<<<<<< HEAD
func _process(_delta: float) -> void:	
=======
<<<<<<< HEAD
func _process(delta: float) -> void:	
>>>>>>> origin/Fruit-Behavior
	pass


func _physics_process(_delta: float) -> void:
	# start dragging
	if (is_dragging):
		# stop the fruits from going outside boundries
		var new_pos = get_global_mouse_position() + drag_offset
		new_pos.x = clamp(new_pos.x, 660, 1300)
		new_pos.y = clamp(new_pos.y, 0, 900)
		global_position = new_pos
	
	# end dragging
	if ((not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and (is_dragging)):
		is_dragging = false
		freeze = false

		# restore collisions
		return
	
	if (not was_dropped and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and GameManager.dropMode):
		# make sure it's not in the name area
		if ((get_global_mouse_position().x < 565 and get_global_mouse_position().x > 204)
		and (get_global_mouse_position().y < 558 and get_global_mouse_position().y > 496)):
			return
		
		# make the fruit a child of game view instead of player behavior
		var current_position = Vector2(global_position.x, global_position.y)
		top_level = true
<<<<<<< HEAD
=======
=======
func _process(_delta: float) -> void:	
	pass


func _physics_process(_delta: float) -> void:
	# start dragging
	if (is_dragging):
		global_position = get_global_mouse_position() + drag_offset
	
	# end dragging
	if ((not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and (is_dragging)):
		is_dragging = false
		freeze = false
		#linear_velocity = Vector2.ZERO
		# Restore collisions
		return
	
	if (not was_dropped and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and GameManager.dropMode):
		# make the fruit a child of game view instead of player behavior
		var current_position = Vector2(global_position.x, global_position.y)
		top_level = true
>>>>>>> origin/Fruit-Behavior
		
		var old_parent = self.get_parent() 
		var new_parent = get_tree().current_scene.get_node("Fruits")
		
		old_parent.remove_child(self)
		new_parent.add_child(self)
		
<<<<<<< HEAD
=======
>>>>>>> origin/main
>>>>>>> origin/Fruit-Behavior
		global_position = current_position
		
		# move it down
		freeze = false
		was_dropped = true
<<<<<<< HEAD
		emit_signal("dropped")
=======
<<<<<<< HEAD
		emit_signal("dropped")	

>>>>>>> origin/Fruit-Behavior
	
	if (was_dropped):
		for body in get_colliding_bodies():
			_handle_collisions(body)


func _handle_collisions(body: Node) -> void:
	# ignore everything that isn't a rigidbody2d
	if not (body is RigidBody2D):
		return
	
	# only one object can handle the "evoludion" of fruits
	if get_instance_id() > body.get_instance_id():
		return
	
	if (was_dropped and body.collision_layer == fruit_type and body.was_dropped):
		set_deferred("contact_monitor", false)
		body.set_deferred("contact_monitor", false)
		
		# if they're watermelons
<<<<<<< HEAD
=======
		if (fruit_type == 13):
=======
		emit_signal("dropped")
	
	if (was_dropped):
		for body in get_colliding_bodies():
			_handle_collisions(body)


func _handle_collisions(body: Node) -> void:
	# ignore everything that isn't a rigidbody2d
	if not (body is RigidBody2D):
		return
	
	# only one object can handle the "evoludion" of fruits
	if get_instance_id() > body.get_instance_id():
		return
	
	if (was_dropped and body.collision_layer == fruit_type):
		set_deferred("contact_monitor", false)
		body.set_deferred("contact_monitor", false)
		
		# if they're watermelons
>>>>>>> origin/Fruit-Behavior
		if (fruit_type == 4096):
			# add score
			GameManager.add_points(1000)
			
			# delete current fruits
			body.queue_free()
			queue_free()
<<<<<<< HEAD
=======
>>>>>>> origin/main
>>>>>>> origin/Fruit-Behavior
			return
		
		# get the new fruit's position
		var fruit_position_x = (global_position.x + body.global_position.x)/2
		var fruit_position_y = (global_position.y + body.global_position.y)/2
		
		var fruit_position = Vector2(fruit_position_x, fruit_position_y)
				
		# create the new fruit
		var fruit_instance = next_fruit.instantiate()
		fruit_instance.global_position = fruit_position
<<<<<<< HEAD
		get_tree().current_scene.get_node("Fruits").call_deferred("add_child", fruit_instance)
		
		# update the score with a giant if statement because i hate myself
		if (fruit_type == 4):
			GameManager.add_points(1)
		else: if (fruit_type == 8):
			GameManager.add_points(3)
		else: if (fruit_type == 16):
			GameManager.add_points(6)
		else: if (fruit_type == 32):
			GameManager.add_points(10)
		else: if (fruit_type == 64):
			GameManager.add_points(15)
		else: if (fruit_type == 128):
			GameManager.add_points(21)
		else: if (fruit_type == 256):
			GameManager.add_points(28)
		else: if (fruit_type == 512):
			GameManager.add_points(36)
		else: if (fruit_type == 1024):
			GameManager.add_points(45)
		else: if (fruit_type == 2048):
			GameManager.add_points(55)
		
		# delete current fruits
=======
<<<<<<< HEAD
		get_tree().current_scene.add_child(fruit_instance)
		
		# delete current fruits
		body.queue_free()
		queue_free()
=======
		get_tree().current_scene.get_node("Fruits").call_deferred("add_child", fruit_instance)
		
		# update the score with a giant if statement because i hate myself
		if (fruit_type == 4):
			GameManager.add_points(1)
		else: if (fruit_type == 8):
			GameManager.add_points(3)
		else: if (fruit_type == 16):
			GameManager.add_points(6)
		else: if (fruit_type == 32):
			GameManager.add_points(10)
		else: if (fruit_type == 64):
			GameManager.add_points(15)
		else: if (fruit_type == 128):
			GameManager.add_points(21)
		else: if (fruit_type == 256):
			GameManager.add_points(28)
		else: if (fruit_type == 512):
			GameManager.add_points(36)
		else: if (fruit_type == 1024):
			GameManager.add_points(45)
		else: if (fruit_type == 2048):
			GameManager.add_points(55)
		
		# delete current fruits
>>>>>>> origin/Fruit-Behavior
		call_deferred("queue_free")
		body.call_deferred("queue_free")


func _on_input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if not (event is InputEventMouseButton):
		return
		
	if (event is InputEventMouseButton):
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
<<<<<<< HEAD
			if (was_dropped and GameManager.moveMode and GameManager.playing):
				is_dragging = true
				freeze = true
				drag_offset = global_position - get_global_mouse_position()
=======
			if (was_dropped and GameManager.moveMode):
				is_dragging = true
				freeze = true
				drag_offset = global_position - get_global_mouse_position()
>>>>>>> origin/main
>>>>>>> origin/Fruit-Behavior
