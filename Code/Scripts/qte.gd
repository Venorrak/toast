extends Node2D
signal _minigame_finished # sent when all actions are done
signal _animation_finished # sent when the leaving animation is done

@export var nbOfQTE: int # number of actions
@export var safeSpace: float # safe space above and below Goals where valid
@export var QTESpeed: float # speed at which qtes go down
@export var separationSpace: int # separation on X between the goals
@export var GoalsY: int # Y coordinates of the goals
@export var topY: int # Y coordinates at which the qtes spawn

@onready var Goals : Node2D = $Goals
@onready var timer : Timer = $StartQte
@onready var AnimStateMachine = $AnimationTree.get("parameters/playback")

const qteObj : PackedScene = preload("res://Scenes/Scenes/qteObj.tscn")

var QTEs : Array = [] # list of the qtes
var QTESpawnIndex : int = 0 # index of QTEs that the timer uses
var QTEFocusIndex : int = 0 # index of the QTE being tracked for player input
var nbOfRight : int = 0
var miniGameEnded : bool = false
const types : Array = ["A", "B", "Up", "Down", "Left", "Right"]
var textures : Array = [
	load("res://Rescources/2d/AButton.png"),
	load("res://Rescources/2d/BButton.png"),
	load("res://Rescources/2d/arrow2.png"),
	load("res://Rescources/2d/arrow2.png"),
	load("res://Rescources/2d/arrow2.png"),
	load("res://Rescources/2d/arrow2.png")
]

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
		newQTE.texture = textures[rand]
		match rand:
			3:
				newQTE.flip_v = true
			4:
				newQTE.flip_v = true
				newQTE.rotation_degrees = 90
			5:
				newQTE.rotation_degrees = 90
				
		newQTE.setType(types[rand])
		newQTE.position = Vector2((separationSpace * rand) + 50, topY)
		newQTE.visible = false
		newQTE.setEnabled(true)
		add_child(newQTE)
		QTEs.append(newQTE)


func _physics_process(delta: float) -> void:
	# when game is finished
	if QTEFocusIndex >= nbOfQTE:
		if miniGameEnded == false:
			miniGameEnded = true
			_minigame_finished.emit(self)
			AnimStateMachine.travel("exitScreen")
	
	for qte in QTEs:
		# change color based on if it is valid to press
		updateQteColor(qte)
		
		# if qte gets out of bounds not valid anymore
		if qte.position.y - GoalsY > safeSpace / 2:
			showGoalResult(false, qte.getType())
			qte.reset()
			qte.setEnabled(false)
			QTEFocusIndex += 1
	
	if !miniGameEnded:
		for type in types:
			if Input.is_action_just_pressed(type):
				if QTEs[QTEFocusIndex].getEnabled() == true:
					var youGotIt : bool = false
					# if the player got the right input
					if QTEs[QTEFocusIndex].getType() == type:
						#and if it was in the safe space where it is valid
						if GoalsY - QTEs[QTEFocusIndex].position.y < safeSpace:
							nbOfRight += 1
							youGotIt = true
					showGoalResult(youGotIt, QTEs[QTEFocusIndex].getType()) # red or green visual to see if they got it right
					QTEs[QTEFocusIndex].reset()
					QTEs[QTEFocusIndex].setEnabled(false)
					QTEFocusIndex += 1

func updateQteColor(qte) -> void:
	if GoalsY - qte.position.y < safeSpace:
		qte.modulate = Color("ffd559", 1)

func _on_start_qte_timeout() -> void:
	if QTESpawnIndex < nbOfQTE:
		if QTEs[QTESpawnIndex].getEnabled() == true:
			QTEs[QTESpawnIndex].visible = true
			QTEs[QTESpawnIndex].setSpeed(QTESpeed)
		QTESpawnIndex += 1

func showGoalResult(gotIt : bool, qteType: String) -> void:
	#seach types array for index corresponding to qteType
	for i in range(len(types)):
		if types[i] == qteType:
			Goals.get_children()[i].startAnim(gotIt)

func getScore() -> float:
	return (nbOfRight * 10) / nbOfQTE
	
func startTimer() -> void:
	timer.start()

func emitAnimEnd() -> void:
	_animation_finished.emit(self)
