extends Control

var leaderboard : Array
@export var names : VBoxContainer
@export var scores : VBoxContainer
@export var mainMenuButton : TextureButton

func _ready() -> void:
	mainMenuButton.grab_focus()
	leaderboardManager.leaderboard.sortScores()
	leaderboard = leaderboardManager.leaderboard.Leaders
	for leaderboardIndex in range(leaderboard.size()):
		names.get_child(leaderboardIndex + 1).text = leaderboard[leaderboardIndex].username
		scores.get_child(leaderboardIndex + 1).text = str(leaderboard[leaderboardIndex].score)
		
func _on_main_menu_btn_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/Scenes/main_menu.tscn")
