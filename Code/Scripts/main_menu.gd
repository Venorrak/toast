extends Control



func _ready() -> void:
	$PlayButton.grab_focus()
	
func _process(delta: float) -> void:
	pass

func _on_play_button_button_up() -> void:
	globalVars.reset()
	get_tree().change_scene_to_file("res://Scenes/Scenes/world.tscn")

func _on_options_button_button_up() -> void:
	pass # Replace with function body.

func _on_quit_button_button_up() -> void:
	get_tree().quit()

func _on_leaderboard_button_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/Scenes/leaderboardMenu.tscn")
