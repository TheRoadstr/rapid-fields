extends Control

@onready var label: Label = $Label
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	label.text = str("Winner: Player ", Global.winner + 1)
	animated_sprite.frame = Global.winner + 1

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
