extends Node2D

@onready var glass_layer: TileMapLayer = $GlassLayer
@onready var player_layer: TileMapLayer = $PlayerLayer
@onready var label: Label = $Camera2D/Label
@onready var camera: Camera2D = $Camera2D

# @onready var card_manager: CardManager = $CardManager
# @onready var card_factory: CardFactory = $CardManager/CardFactory
# @onready var hands = [$CardManager/Hand1, $CardManager/Hand2, $CardManager/Hand3, $CardManager/Hand4]

var rng = RandomNumberGenerator.new()

var mad_coords = [3, 1]
var homeless_coords = [5, 1]
var crazy_coords = [7, 1]
var ribbit_coords = [9, 1]
var bunny_coords = [mad_coords, homeless_coords, crazy_coords, ribbit_coords]

var bunny_alive = [3, 3, 3, 3]

var cards = {"skip" : 350, "control" : 300, "swap" : 200, "steal" : 150}

var game_over = false
var difficulty = 1

var glass = []
var dangers = []

var cols
var rows = 20

var click = [0, 0]
signal clicked
var clicking = false

@onready var life_1: AnimatedSprite2D = $Camera2D/Control/Life1
@onready var life_2: AnimatedSprite2D = $Camera2D/Control/Life2
@onready var life_3: AnimatedSprite2D = $Camera2D/Control/Life3

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var playerposition = get_global_mouse_position()
		click = [int(floor(playerposition[0] / 16)), int(floor(playerposition[1] / 16))]
		print("Mouse Click at: ", click)
	
	if event is InputEventMouseButton and event.pressed:
		clicking = true
		clicked.emit()
	else:
		clicking = false

func _ready() -> void:
	rng.randomize()
	setupboard()

func setupboard():
	print("Setting up the board")
	match difficulty:
		0:
			cols = 4
			print("Difficulty set to easy")
		1:
			cols = 3
			print("Difficulty set to normal")
		2:
			cols = 2
			print("Difficulty set to hard")
	
	for i in bunny_coords.size():
		player_layer.set_cell(Vector2i(bunny_coords[i][0], bunny_coords[i][1]), 0, Vector2i(i, 0))
		print("Placed player ", i + 1, " in position ", bunny_coords[i][0], ",", bunny_coords[i][1])
	
	var row
	var column
	var danger
	
	for i in rows:
		for t in cols:
			match cols:
				2: column = 5 + (t * 2)
				3: column = 4 + (t * 2)
				4: column = 3 + (t * 2)
			row = 3 + (i * 2)
			glass_layer.set_cell(Vector2i(column, row), 1, Vector2i(1, 0))
			glass.append([column, row])
		
		danger = rng.randi_range(1, cols)
		match cols:
			2: dangers.append([3 + (danger * 2), 3 + (i * 2)])
			3: dangers.append([2 + (danger * 2), 3 + (i * 2)])
			4: dangers.append([1 + (danger * 2), 3 + (i * 2)])
	
	glass_layer.set_cell(Vector2i(6, 43), 1, Vector2i(1, 0))
	glass.append([6, 43])
	
	print("Glass coordinates: ", glass)
	print("Dangerous coordinates: ", dangers)
	
	# for i in hands.size():
		# for n in 3:
			# card_factory.create_card(card_rarity(), hands[i])
		# hands[i].position = Vector2(9999, 9999)
	
	camera.position = Vector2(104, 24)
	
	gameloop()

func gameloop():
	print("Starting game loop")
	while game_over == false:
		for i in range(4):
			if bunny_alive[i]:
				camera.position = Vector2(104, bunny_coords[i][1] * 16 + 8)
				match i:
					0:
						label.text = "First's turn"
						# hands[0].position = Vector2(0, 0)
					1:
						label.text = "Second's turn"
						# hands[1].position = Vector2(0, 0)
					2:
						label.text = "Third's turn"
						# hands[2].position = Vector2(0, 0)
					3:
						label.text = "Fourth's turn"
						# hands[3].position = Vector2(0, 0)
				
				bunny_lives(bunny_alive[i])
				
				while true:
					await wait_for_click()
					clicking = false
					if click in glass and click[1] == bunny_coords[i][1] + 2:
						break
					print("Invalid move, try again")
				
				player_layer.erase_cell(Vector2i(bunny_coords[i][0], bunny_coords[i][1]))
				bunny_coords[i][0] = click[0]
				bunny_coords[i][1] = click[1]
				player_layer.set_cell(Vector2i(bunny_coords[i][0], bunny_coords[i][1]), 0, Vector2i(i, 0))
				print("Moved player ", i + 1, " to coordinates [", bunny_coords[i][0], ", ", bunny_coords[i][1], "]")
				
				if bunny_coords[i] in dangers:
					print(bunny_alive[i])
					bunny_alive[i] -= 1
					print(bunny_alive[i], " lives left")
					glass_layer.set_cell(Vector2i(bunny_coords[i][0], bunny_coords[i][1]), 1, Vector2i(0, 0))
					bunny_lives(bunny_alive[i])
					
					if bunny_alive[i] <= 0:
						player_layer.erase_cell(Vector2i(bunny_coords[i][0], bunny_coords[i][1]))
						bunny_coords[i] = [-255, -255]
						print("Player ", i + 1, " has perished!")
					
					await get_tree().create_timer(0.5).timeout
				
				if bunny_coords[i] == [6, 43]:
					winning(i)
				
				for t in range(4):
					if t != i:
						player_layer.set_cell(Vector2i(bunny_coords[t][0], bunny_coords[t][1]), 0, Vector2i(t, 0))
			
			# if i < 4:
				# hands[i].position = Vector2(9999, 9999)
		
		print(bunny_alive[0], bunny_alive[1], bunny_alive[2], bunny_alive[3])
		
		if !bunny_alive[0] and !bunny_alive[1] and !bunny_alive[2] and !bunny_alive[3]:
			game_over = true
			print("Game has ended")
	
	await get_tree().create_timer(1).timeout
	print("Going to main menu")
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func wait_for_click():
	if clicking:
		return
	await clicked

func card_rarity():
	var weighted_sum = 0
	
	for i in cards:
		weighted_sum += cards[i]
	
	var item = rng.randi_range(0, weighted_sum)
	
	for i in cards:
		if item <= cards[i]:
			return i
		item -= cards[i]

func bunny_lives(index):
	if index == 3:
		life_1.frame = 0
		life_2.frame = 0
		life_3.frame = 0
	elif index == 2:
		life_1.frame = 0
		life_2.frame = 0
		life_3.frame = 1
	elif index == 1:
		life_1.frame = 0
		life_2.frame = 1
		life_3.frame = 1
	else:
		life_1.frame = 1
		life_2.frame = 1
		life_3.frame = 1

func winning(player):
	print(player)
	Global.winner = player
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
