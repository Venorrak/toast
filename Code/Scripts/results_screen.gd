extends Control

@onready var RedLabels = $Control/ScorePanelRed/Scores
@onready var BlueLabels = $Control/ScorePanelBlue/Scores
var redScores : Array = []
var blueScores : Array = []

func _ready() -> void:
	$Control/mainMenuBtn.grab_focus()
	
	var blues : Array = BlueLabels.get_children()
	var reds = RedLabels.get_children()
	
	if blueScores.size() != 0:
		for i in blues.size():
			blues[i].text = str(blueScores[i])
	
	if redScores.size() != 0:
		for i in reds.size():
			reds[i].text = str(redScores[i])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func updateBlueScore(Score : Array) -> void:
	blueScores = Score
		
func updateRedScore(Score : Array) -> void:
	redScores = Score


func _on_main_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Scenes/main_menu.tscn")


func _on_new_game_btn_pressed() -> void:
	globalVars.reset()
	get_tree().reload_current_scene()
