extends CanvasLayer

func _on_try_again_button_pressed() -> void:
	get_tree().reload_current_scene()  # Reload the current scene to restart the game

func _on_quit_button_pressed() -> void:
	get_tree().quit()  # Quit the game
