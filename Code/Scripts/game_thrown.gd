extends BaseState
class_name GameThrown

@export var thisWorld : World
@export var toaster : Sprite2D
@export var target : Sprite2D
@export var toastHome : Node2D
@export var HUD : CanvasLayer
@export var progressBar : Node2D

@onready var ResultsScene : PackedScene = preload("res://Scenes/Scenes/resultsScreen.tscn")

var gameEnded : bool = false # is the game ended

func handle_inputs() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	handle_inputs()
	# update progress bar
	var deltaPosToastTargetY : float = target.position.y - globalVars.toastStartPosition.y
	progressBar.setProgress((100 - ((target.position.y - globalVars.currentToast.position.y) * 100) / deltaPosToastTargetY))
	
	#make toaster invisible if the toast goes back down
	if globalVars.currentToast.linear_velocity.y > 0 && toaster.visible == true:
		toaster.visible = false
		
	if globalVars.currentToast.linear_velocity.length() < 5:
		#if the toast is further than the valid distance from the target
		if (globalVars.currentToast.global_position - target.global_position).length() > globalVars.ValidToastDistance:
			globalVars.currentToast.position = Vector2(100000, 1000000) # no queue_free because of result screen resons
		
		#if the game is not finished
		if globalVars.nbOfToasts > 0:
			thisWorld.getCreateToast()
			toaster.visible = true
			globalVars.rotationSpeed = globalVars.rotationSpeedInit
			globalVars.gaugeSpeed = globalVars.gaugeSpeedInit
			Transitioned.emit(self, "GameDirection")
		
		# else the game is finished
		else:
			if gameEnded == false:
				gameEnded = true
				gameEnding()

func enter() -> void:
	pass

func exit() -> void:
	pass

func gameEnding() -> void:
	var redTeamScore : Array = []
	var blueTeamScore : Array = []
	var redTeamScoreTotal : int = 0
	var blueTeamScoreTotal : int = 0
	
	for toast in toastHome.get_children():
		var toastScore = int((toast.global_position - target.global_position).length())
		if toast.getTeam() == 0:
			if toastScore > globalVars.ValidToastDistance:
				blueTeamScore.append(globalVars.ValidToastDistance)
			else:
				blueTeamScore.append(toastScore)
			blueTeamScoreTotal += blueTeamScore[-1]
		else:
			if toastScore > globalVars.ValidToastDistance:
				redTeamScore.append(globalVars.ValidToastDistance)
			else:
				redTeamScore.append(toastScore)
			redTeamScoreTotal += redTeamScore[-1]
	redTeamScore.append(redTeamScoreTotal)
	blueTeamScore.append(blueTeamScoreTotal)
	
	var newResultScene = ResultsScene.instantiate()
	newResultScene.updateBlueScore(blueTeamScore)
	newResultScene.updateRedScore(redTeamScore)
	HUD.add_child(newResultScene)
