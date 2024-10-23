extends Node2D
signal _minigame_finished
signal _animation_finished

@export var nbOfQTE: int
@export var safeSpace: float
@export var QTESpeed: float
@export var separationSpace: int
@export var GoalsY: int
@export var topY: int

@onready var Goals : Node2D = $Goals
@onready var timer : Timer = $StartQte
@onready var AnimStateMachine = $AnimationTree.get("parameters/playback")

var qteObj : PackedScene = preload("res://Scenes/Scenes/qteObj.tscn")

var QTEs : Array = []
var QTEIndex:int = 0
var QTEAtIndex:int = 0
var nbOfRight:int = 0
var types : Array = ["A", "B", "Up", "Down", "Left", "Right"]
var gameEnded : bool = false

func _ready() -> void:
	Goals.position.y = GoalsY
	#setup goals
	var goalChildren = Goals.get_children()
	for i in range(len(goalChildren)):
		goalChildren[i].position.x = (i * separationSpace) + 50
		
	#create qtes
	for i in nbOfQTE:
		var newQTE : Sprite2D = qteObj.instantiate()
		var rand : int = randi_range(0,5)
		match rand:
			0:
				newQTE.texture = load("res://Rescources/2d/AButton.png")
			1:
				newQTE.texture = load("res://Rescources/2d/BButton.png")
			2:
				newQTE.texture = load("res://Rescources/2d/arrow2.png")
			3:
				newQTE.texture = load("res://Rescources/2d/arrow2.png")
				newQTE.flip_v = true
			4:
				newQTE.texture = load("res://Rescources/2d/arrow2.png")
				newQTE.flip_v = true
				newQTE.rotation_degrees = 90
			5:
				newQTE.texture = load("res://Rescources/2d/arrow2.png")
				newQTE.rotation_degrees = 90
				
		newQTE.setType(types[rand])
		newQTE.position = Vector2((separationSpace * rand) + 50, topY)
		newQTE.visible = false
		newQTE.setEnabled(true)
		add_child(newQTE)
		QTEs.append(newQTE)


func _physics_process(delta: float) -> void:
	if QTEAtIndex >= nbOfQTE:
		if gameEnded == false:
			gameEnded = true
			_minigame_finished.emit(self)
			AnimStateMachine.travel("exitScreen")
	for qte in QTEs:
		if GoalsY - qte.position.y < safeSpace:
			qte.modulate = Color("ffd559", 1)
		if qte.position.y - GoalsY > safeSpace / 2:
			showGoalResult(false, qte.getType())
			qte.reset()
			qte.setEnabled(false)
			QTEAtIndex += 1
	for type in types:
		if Input.is_action_just_pressed(type):
			if QTEAtIndex < nbOfQTE:
				if QTEs[QTEAtIndex].visible == true:
					var youGotIt : bool = false
					if QTEs[QTEAtIndex].getType() == type:
						if GoalsY - QTEs[QTEAtIndex].position.y < safeSpace:
							nbOfRight += 1
							youGotIt = true
					showGoalResult(youGotIt, QTEs[QTEAtIndex].getType())
					QTEs[QTEAtIndex].reset()
					QTEs[QTEAtIndex].setEnabled(false)
					QTEAtIndex += 1

func _on_start_qte_timeout() -> void:
	if QTEIndex < nbOfQTE:
		if QTEs[QTEIndex].getEnabled() == true:
			QTEs[QTEIndex].visible = true
			QTEs[QTEIndex].setSpeed(QTESpeed)
			QTEIndex += 1

func showGoalResult(gotIt : bool, qteType: String) -> void:
	#seach types array for index corresponding to qteType
	for i in range(len(types)):
		if types[i] == qteType:
			Goals.get_children()[i].startAnim(gotIt)
	pass

func getScore() -> float:
	return (nbOfRight * 10) / nbOfQTE
	
func startTimer() -> void:
	timer.start()

func emitAnimEnd() -> void:
	_animation_finished.emit(self)
