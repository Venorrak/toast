extends Control

@export var RedLabels : Control
@export var BlueLabels : Control
@export var mainMenuButton : Button
@export var newGameButton : Button
@export var showTeamLabel : RichTextLabel
@export var selectorParent : Control
@export var arrows : Control

enum screenState {RESULTS, NEWSCORE}

var currentState : screenState = screenState.RESULTS
var redScores : Array = [1000, 1000, 1000, 550000]
var blueScores : Array = [1000, 1000, 1000, 550000]
var buttonsEnabled : bool = true

var cursorPosition : int = 0
var letterChoices : Array = [0, 0, 0]
var availablesCharacters : Array = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

func _ready() -> void:
	
	var blues : Array = BlueLabels.get_children()
	var reds = RedLabels.get_children()
	
	if blueScores.size() != 0:
		for i in blues.size():
			blues[i].text = str(blueScores[i])
	
	if redScores.size() != 0:
		for i in reds.size():
			reds[i].text = str(redScores[i])
			
	if leaderboardManager.isScoreInTopTen(redScores[3]) or leaderboardManager.isScoreInTopTen(blueScores[3]):
		print("is in top")
		print(leaderboardManager.leaderboard.Leaders)
		setScene(true)
		if redScores[3] >= blueScores[3]:
			setTeamLabel("red", redScores[3])
		else:
			setTeamLabel("blue", blueScores[3])
	else:
		mainMenuButton.grab_focus()

func _process(delta: float) -> void:
	if currentState == screenState.NEWSCORE:
		updateSelectors()
		updateCursor()
		
		if Input.is_action_just_pressed("interact"):
			saveScore()
			setScene(false)
			mainMenuButton.grab_focus()

func saveScore() -> void:
	var registerScore : int = redScores[3] if redScores[3] > blueScores[3] else blueScores[3]
	var registerName : String = ""
	for selectorIndex in range(3):
		registerName += availablesCharacters[letterChoices[selectorIndex]]
	print(registerName)
	print(registerScore)
	leaderboardManager.addNewScore(registerScore, registerName)
	leaderboardManager.saveLeaderboard()

func updateSelectors() -> void:
	if Input.is_action_just_pressed("Up"):
		if letterChoices[cursorPosition] == availablesCharacters.size() - 1:
			letterChoices[cursorPosition] = 0
		else:
			letterChoices[cursorPosition] += 1
	if Input.is_action_just_pressed("Down"):
		if letterChoices[cursorPosition] == 0:
			letterChoices[cursorPosition] = availablesCharacters.size()
		letterChoices[cursorPosition] -= 1
	if Input.is_action_just_pressed("Left"):
		if cursorPosition > 0:
			cursorPosition -= 1
	if Input.is_action_just_pressed("Right"):
		if cursorPosition < 3:
			cursorPosition += 1
	
	for selectorIndex in range(3):
		selectorParent.get_child(selectorIndex).text = buildLabelString(120, Color("#FFFFFF"), availablesCharacters[letterChoices[selectorIndex]])	

func updateCursor() -> void:
	arrows.position.x = selectorParent.get_child(cursorPosition).position.x

func updateBlueScore(Score : Array) -> void:
	blueScores = Score
		
func updateRedScore(Score : Array) -> void:
	redScores = Score

func setButtonEnabled(enabled : bool) -> void:
	mainMenuButton.disabled = not enabled
	newGameButton.disabled = not enabled

func setScene(newScore : bool):
	if newScore:
		$HighScore.visible = true
		$Results.visible = false
		setButtonEnabled(false)
		currentState = screenState.NEWSCORE
	else:
		$HighScore.visible = false
		$Results.visible = true
		setButtonEnabled(true)
		currentState = screenState.RESULTS

func setTeamLabel(team : String, score : int):
	if team == "blue":
		showTeamLabel.text = buildLabelString(70, Color.from_string(team, Color("#FFFFFF")), "Blue Team", score)
	elif team == "red":
		showTeamLabel.text = buildLabelString(70, Color.from_string(team, Color("#FFFFFF")), "Red Team", score)
	else:
		showTeamLabel.text = buildLabelString(70, Color("#FFFFFF"), "error")

func buildLabelString(fontSize : int, color : Color = Color("#FFFFFF"), text : String = "", score : int = 0) -> String:
	var outputString : String = ""
	outputString += "[center][font_size=" + str(fontSize) + "][color=" + str(color.to_html(false)) + "]"
	outputString += text
	if score != 0:
		outputString += " : " + str(score)
	outputString += "[/color][/font_size][/center]"
	return outputString
	
func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Scenes/main_menu.tscn")


func _on_new_game_btn_pressed() -> void:
	globalVars.reset()
	get_tree().reload_current_scene()
