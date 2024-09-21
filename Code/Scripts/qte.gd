extends Node2D
@export var nbOfQTE: int
@export var safeSpace: float
@export var QTESpeed: float
@export var separationSpace: int
@export var GoalsY: int

@onready var Goals = $Goals
var qteObj = preload("res://Scenes/Scenes/qteObj.tscn")

var QTEs = []
var QTEIndex:int = 0
var QTEAtIndex:int = 0
var nbOfRight:int = 0
var types = ["A", "B", "Up", "Down", "Left", "Right"]

func _ready() -> void:
	Goals.position.y = GoalsY
	#setup goals
	var goalChildren = Goals.get_children()
	for i in range(len(goalChildren)):
		goalChildren[i].position.x = (i * separationSpace) + 50
		
	#create qtes
	for i in nbOfQTE:
		var newQTE = qteObj.instantiate()
		var rand = randi_range(0,5)
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
		newQTE.position = Vector2((separationSpace * rand) + 50, 0)
		newQTE.visible = false
		add_child(newQTE)
		QTEs.append(newQTE)


func _physics_process(delta: float) -> void:
	for qte in QTEs:
		if GoalsY - qte.position.y < safeSpace:
			qte.modulate = Color("ffffff", 0.5)
	for type in types:
		if Input.is_action_just_pressed(type):
			if QTEAtIndex < nbOfQTE:
				QTEs[QTEAtIndex].visible = false
				if QTEs[QTEAtIndex].getType() == type:
					if GoalsY - QTEs[QTEAtIndex].position.y < safeSpace:
						nbOfRight += 1
				QTEAtIndex += 1
			else:
				print(nbOfRight)


func _on_start_qte_timeout() -> void:
	if QTEIndex < nbOfQTE:
		QTEs[QTEIndex].visible = true
		QTEs[QTEIndex].setSpeed(QTESpeed)
		QTEIndex += 1
