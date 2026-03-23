extends Node2D

# firebase database url
const FIREBASE_DB_URL = "https://aylins-suika-game-default-rtdb.firebaseio.com/"

# manager variables
var score : int = 0
var fruit_dropped : bool = false
var playing : bool = true
var lost : bool = false
var dropMode : bool = true
var moveMode : bool = false

# ui variables
var current_score : Label
var best_score : Label
var game_over : Node2D
var leaderboard_labels : Array = []
var name_input : LineEdit
var player_id : String = ""

# signals
signal reset

# eported variables
@export var fruits: Array[Texture2D] = [
	preload("res://Art/cherry.png"),
	preload("res://Art/strawberry.png"),
	preload("res://Art/grape.png"),
	preload("res://Art/dekopan.png"),
	preload("res://Art/persimmon.png")]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set the current score to 0
	current_score = get_tree().current_scene.get_node("CanvasLayer").get_child(2)
	best_score = get_tree().current_scene.get_node("CanvasLayer").get_child(1)

	current_score.text = "0"
	
	# set up player identity and load saved data
	_ensure_player_id()
	var saved_best = _load_best_score()
	best_score.text = str(saved_best)
	
	# get game over screen
	game_over = get_tree().current_scene.get_node("CanvasLayer").get_child(3)
	
	# leaderboard UI references
	var canvas = get_tree().current_scene.get_node("CanvasLayer")
	for i in range(6, 11):
		leaderboard_labels.append(canvas.get_child(i))
	
	name_input = canvas.get_child(12)
	_load_saved_name()
	_load_leaderboard_from_server()
	
	# ignore the box
	var box = get_tree().current_scene.get_node("Box")
	
	for child in box.get_children():
		if child is Control:
			child.mouse_filter = Control.MOUSE_FILTER_IGNORE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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


func _game_over():
	playing = false
	lost = true
		
	# check to see if the current score is the new best score
	if (score > int(best_score.text)):
		best_score.text = current_score.text
		_save_best_score(score)
			
	game_over.visible = true
	
	# update scores
	game_over.get_child(1).text = current_score.text
	game_over.get_child(2).text = best_score.text
	
	# submit to leaderboard
	var player_name = name_input.text.strip_edges()
	
	if player_name == "":
		# if they don't have a name
		player_name = "Anonymous"
	
	_save_player_name(player_name)
	_submit_score(player_name, int(best_score.text))


func reset_game():
	# ui + game states
	game_over.visible = false
	lost = false
	playing = true
	
	# ready the player and game manager to hard reset
	emit_signal("reset")
	score = 0
	current_score.text = "0"
	
	# delete all current fruits
	var children = get_tree().current_scene.get_node("Fruits").get_children()
	var player_child = get_tree().current_scene.get_node("Player").get_child(2)
	
	for child in children:
		child.queue_free()
	
	player_child.get_parent().remove_child(player_child)
	
	# reset modes
	moveMode = false
	dropMode = true


func _input(event):
	if (event is InputEventKey and playing):
		if (event.keycode == KEY_D):
			dropMode = true
			moveMode = false
			
			# update ui
			get_tree().current_scene.get_node("CanvasLayer").get_child(5).text = "Drop Mode Active"
		
		if (event.keycode == KEY_M):
			dropMode = false
			moveMode = true
			
			# update ui
			get_tree().current_scene.get_node("CanvasLayer").get_child(5).text = "Move Mode Active"


# prob could've used cookies for this lol
func _save_best_score(value: int) -> void:
	# check if player is on website
	if (OS.has_feature("web")):
		JavaScriptBridge.eval("window.localStorage.setItem('best_score', '%s');" % str(value))
	else:
		# if on non web, save in a file
		var config = ConfigFile.new()
		config.set_value("score", "best", value)
		config.save("user://best_score.cfg")


func _load_best_score() -> int:
	# if the player is on a website
	if OS.has_feature("web"):
		# grab the best score from the local storage
		var result = JavaScriptBridge.eval("window.localStorage.getItem('best_score');")
		
		if result != null and result != "":
			return int(result)
		
		return 0
	else:
		# if on desktop, grab from the file made before
		var config = ConfigFile.new()
		
		if config.load("user://best_score.cfg") == OK:
			return config.get_value("score", "best", 0)
		
		return 0


# scary firebase stuff below, stop scrolling past this for sanity
func _load_leaderboard_from_server() -> void:
	if not OS.has_feature("web"):
		return
	
	JavaScriptBridge.eval("window._lb_result = null;")
	
	var js = """
		fetch('%s/leaderboard.json')
			.then(function(r) { return r.json(); })
			.then(function(data) {
				if (!data) { window._lb_result = '[]'; return; }
				var entries = Object.values(data);
				entries.sort(function(a, b) { return b.score - a.score; });
				window._lb_result = JSON.stringify(entries.slice(0, 5));
			})
			.catch(function() { window._lb_result = '[]'; });
	""" % FIREBASE_DB_URL
	JavaScriptBridge.eval(js)
	
	# poll for the async fetch result
	for i in range(10):
		await get_tree().create_timer(0.3).timeout
		var result = JavaScriptBridge.eval("window._lb_result;")
		if result != null:
			var json = JSON.new()
			if json.parse(result) == OK and json.data is Array:
				_update_leaderboard_labels(json.data)
			return


func _submit_score(player_name: String, player_best_score: int) -> void:
	if not OS.has_feature("web") or player_id == "":
		return
	
	var safe_name = player_name.replace("\\", "\\\\").replace("'", "\\'")
	var safe_id = player_id.replace("\\", "\\\\").replace("'", "\\'")
	var js = """
		fetch('%s/leaderboard/%s.json', {
			method: 'PUT',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify({ name: '%s', score: %d })
		}).then(function() { window._score_submitted = 'true'; });
	""" % [FIREBASE_DB_URL, safe_id, safe_name, player_best_score]
	JavaScriptBridge.eval(js)
	
	await get_tree().create_timer(1.0).timeout
	_load_leaderboard_from_server()


func _update_leaderboard_labels(entries: Array) -> void:
	for i in range(leaderboard_labels.size()):
		if i < entries.size():
			leaderboard_labels[i].text = "%s | %s" % [entries[i]["name"], str(int(entries[i]["score"]))]
		else:
			leaderboard_labels[i].text = "--- | ---"


func _ensure_player_id() -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval(
			"if (!localStorage.getItem('player_id')) { localStorage.setItem('player_id', crypto.randomUUID()); }"
		)
		player_id = JavaScriptBridge.eval("localStorage.getItem('player_id');")
	else:
		var config = ConfigFile.new()
		if config.load("user://player.cfg") == OK:
			player_id = config.get_value("identity", "id", "")
		if player_id == "":
			player_id = str(randi()) + str(randi())
			config.set_value("identity", "id", player_id)
			config.save("user://player.cfg")


func _load_saved_name() -> void:
	if OS.has_feature("web"):
		var saved_name = JavaScriptBridge.eval("localStorage.getItem('player_name');")
		if saved_name != null and saved_name != "":
			name_input.text = saved_name


func _save_player_name(player_name: String) -> void:
	if OS.has_feature("web"):
		var safe = player_name.replace("\\", "\\\\").replace("'", "\\'")
		JavaScriptBridge.eval("localStorage.setItem('player_name', '%s');" % safe)
