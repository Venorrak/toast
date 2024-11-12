extends Node
class_name LeaderboardManager

var save_file_path = "user://save/"
var save_file_name = "Leaderboard.tres"

var leaderboard : Leaderboard = Leaderboard.new()

func _ready() -> void:
	verifySaveDirectory(save_file_path)
	loadLeaderboard()
	
func verifySaveDirectory(path : String) -> void:
	DirAccess.make_dir_absolute(path)
	
func loadLeaderboard() -> void:
	leaderboard = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	
func saveLeaderboard() -> void:
	ResourceSaver.save(leaderboard, save_file_path + save_file_name)
	
func isScoreInTopTen(score : int) -> bool:
	return leaderboard.isScoreInTopTen(score)

func addNewScore(score: int, username: String) -> void:
	leaderboard.addNewTopScore(score, username)
