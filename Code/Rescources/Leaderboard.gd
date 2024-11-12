extends Resource
class_name Leaderboard

@export var Leaders : Array = []

func isScoreInTopTen(score : int) -> bool:
	var inTop : bool = false
	if Leaders.size() < 10:
		return true
	for topScore in Leaders:
		if topScore.score > score:
			inTop = true
	return inTop
	
func sortDescending(a, b):
	if a.score < b.score:
		return true
	return false
	
func sortScores() -> void:
	Leaders.sort_custom(sortDescending)
	
func addNewTopScore(score : int, username : String) -> void:
	if isScoreInTopTen(score):
		if Leaders.size() == 10:
			Leaders.remove_at(0)
		var newScore : Score = Score.new(username, score)
		Leaders.append(newScore)
		sortScores()
