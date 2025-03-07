extends Node2D

@onready var glass_layer: TileMapLayer = $GlassLayer
@onready var player_layer: TileMapLayer = $PlayerLayer
@onready var label: Label = $Label

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

var click = [0, 0]
signal clicked
var clicking = false

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var playerposition = event.position
		click = [int(floor(playerposition[0] / 16)), int(floor(playerposition[1] / 16))]
		print("Mouse Click at: ", click)
	
	if event is InputEventMouseButton and event.pressed:
		clicking = true
		clicked.emit()
	else:
		clicking = false

func _ready() -> void:
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
	print("Starting game loop")
	while game_over == false:
		var index = 0
		while index < 5:
			if index == 4:
				index = 0
			if bunny_alive[index]:
				match index:
					0: label.text = "First's turn"
					1: label.text = "Second's turn"
					2: label.text = "Third's turn"
					3: label.text = "Fourth's turn"
				await wait_for_click()
				clicking = false
				if click in glass and click[1] == bunny_coords[index][1] + 2:
					player_layer.erase_cell(Vector2i(bunny_coords[index][0], bunny_coords[index][1]))
					bunny_coords[index][0] = click[0]
					bunny_coords[index][1] = click[1]
					player_layer.set_cell(Vector2i(bunny_coords[index][0], bunny_coords[index][1]), 0, Vector2i(index, 0))
					print("Moved player ", index + 1, " to coordinates [", bunny_coords[index][0], ", ", bunny_coords[index][1], "]")
					if bunny_coords[index] in dangers:
						bunny_alive[index] = false
						print("Player ", index + 1, " has perished!")
					index += 1
			else:
				index += 1
		
		if !mad_alive and !homeless_alive and !crazy_alive and !ribbit_alive:
			game_over = true

func wait_for_click():
	if clicking:
		return
	await clicked
