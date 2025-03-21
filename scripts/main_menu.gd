extends Control

func _on_play_pressed() -> void:
	print("Starting game")
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_quit_pressed() -> void:
	print("Closing game")
	get_tree().quit()

func _on_credits_pressed() -> void:
	print("Showing Credits")
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func _on_options_pressed() -> void:
	print("Configuring game")
	get_tree().change_scene_to_file("res://scenes/options.tscn")
