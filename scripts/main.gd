extends Node2D

@onready var glass_layer: TileMapLayer = $GlassLayer
@onready var player_layer: TileMapLayer = $PlayerLayer


var rng = RandomNumberGenerator.new()

var mad_coords = [3, 1]
var homeless_coords = [5, 1]
var crazy_coords = [7, 1]
var ribbit_coords = [9, 1]
var bunny_coords = [mad_coords, homeless_coords, crazy_coords, ribbit_coords]

var mad_alive = true
var homeless_alive = true
var crazy_alive = true
var ribbit_alive = true
var bunny_alive = [mad_alive, homeless_alive, crazy_alive, ribbit_alive]

var game_over = false
var difficulty = 2

var glass = []
var dangers = []

var cols
var rows = 20

<<<<<<< HEAD
<<<<<<< HEAD
var click = []

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		click = [floor(event.position[0] / 16), floor(event.position[1] / 16)]

=======
>>>>>>> parent of 5273251 (detect clicks)
=======
>>>>>>> parent of 5273251 (detect clicks)
func _ready() -> void:
	setupboard()

func setupboard():
	print("Setting up the board")
	match difficulty:
		0:
			cols = 2
			print("Difficulty set to easy")
		1:
			cols = 3
			print("Difficulty set to normal")
		2:
			cols = 4
			print("Difficulty set to hard")
	
	for i in bunny_coords.size():
		player_layer.set_cell(Vector2i(bunny_coords[i][0], bunny_coords[i][1]), 0, Vector2i(i, 0))
		print("Placed player ", i + 1, " in position ", bunny_coords[i][0], ",", bunny_coords[i][1])
	
	var row
	var column
	var danger
	
	for i in rows:
		for t in cols:
			column = 3 + (t * 2)
			row = 3 + (i * 2)
			glass_layer.set_cell(Vector2i(column, row), 0, Vector2i(0, 0))
			glass.append([column, row])
		danger = rng.randi_range(1, cols)
		dangers.append([1 + (danger * 2), 3 + (i * 2)])
	print("Glass coordinates: ", glass)
	print("Dangerous coordinates: ", dangers)
	gameloop()

func gameloop():
	print("Moving a player")
	while game_over == false:
		for i in 4:
<<<<<<< HEAD
<<<<<<< HEAD
			if bunny_alive[i]:
				await moveplayer(i)
=======
=======
>>>>>>> parent of 5273251 (detect clicks)
			print("Player ", i + 1, "\'s turn")
			#if bunny_alive[i]:
				#moveplayer(i)
			#else:
				#break
<<<<<<< HEAD
>>>>>>> parent of 5273251 (detect clicks)
=======
>>>>>>> parent of 5273251 (detect clicks)
		
		if !mad_alive and !homeless_alive and !crazy_alive and !ribbit_alive:
			game_over = true
		
		break

<<<<<<< HEAD
<<<<<<< HEAD
func moveplayer(player):
	print("Starting to move player")
	await waitingclick()
	print("Finished waiting for click")
	for i in glass:
		if click == i:
			print("Moving player ", player + 1)
			player_layer.erase_cell(Vector2i(bunny_coords[player][0], bunny_coords[player][1]))
			bunny_coords[player] = click
			player_layer.set_cell(Vector2i(bunny_coords[player][0], bunny_coords[player][1]), 0, Vector2i(player, 0))
=======
#func moveplayer(player):
>>>>>>> parent of 5273251 (detect clicks)
=======
#func moveplayer(player):
>>>>>>> parent of 5273251 (detect clicks)
	
func waitingclick():
	print("Waiting for click")
	click = null
	while click == null:
		await get_tree().process_frame
