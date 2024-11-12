extends Control

var leaderboard : Array
@export var names : VBoxContainer
@export var scores : VBoxContainer

func _ready() -> void:
	leaderboardManager.leaderboard.sortScores()
	leaderboard = leaderboardManager.leaderboard.Leaders
	for leaderboardIndex in range(leaderboard.size()):
		names.get_child(leaderboardIndex + 1).text = leaderboard[leaderboardIndex].username
		scores.get_child(leaderboardIndex + 1).text = str(leaderboard[leaderboardIndex].score)
