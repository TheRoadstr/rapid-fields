extends Control

func _on_easy_pressed() -> void:
	Global.difficulty = 0

func _on_medium_pressed() -> void:
	Global.difficulty = 1

func _on_hard_pressed() -> void:
	Global.difficulty = 2

func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
