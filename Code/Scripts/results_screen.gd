extends Control

@onready var RedLabels = $Control/ScorePanelRed/Scores
@onready var BlueLabels = $Control/ScorePanelBlue/Scores
var redScores
var blueScores

func _ready() -> void:
	$Control/mainMenuBtn.grab_focus()
	var blues = BlueLabels.get_children()
	for i in blues.size():
		blues[i].text = str(blueScores[i])
	var reds = RedLabels.get_children()
	for i in reds.size():
		reds[i].text = str(redScores[i])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func updateBlueScore(Score) -> void:
	blueScores = Score
		
func updateRedScore(Score) -> void:
	redScores = Score


func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Scenes/main_menu.tscn")


func _on_new_game_btn_pressed() -> void:
	get_tree().reload_current_scene()
