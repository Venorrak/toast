extends BaseState
class_name GamePower

@export var thisWorld : World
@export var HUD : CanvasLayer
@export var gauge : TextureProgressBar
@export var target : Sprite2D
@export var gaugeLabel : RichTextLabel

var variationPercentage : float = 10 # max variation of the power output. if you change don't forget to change in qte.gd too

var QTEScene : PackedScene = preload("res://Scenes/Scenes/qte.tscn")


func handle_inputs() -> void:
	if Input.is_action_just_pressed("interact"):
		globalVars.toastSpeed = gauge.value
		globalVars.gaugeSpeed = 0
		var minigame = QTEScene.instantiate()
		minigame.connect("_minigame_finished", minigameFinished)
		minigame.connect("_animation_finished", minigameAnimFinished)
		HUD.add_child(minigame)
		Transitioned.emit(self, "GameWaiting")

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	handle_inputs()
	if globalVars.gaugeSpeed != 0:
		gauge.value += globalVars.gaugeSpeed
		if gauge.value >= globalVars.maxSpeed or gauge.value <= 0:
			globalVars.gaugeSpeed *= -1
		ShowOnGaugeLabel(int((gauge.value * 100) / globalVars.maxSpeed))

func enter() -> void:
	pass

func exit() -> void:
	pass
	
func minigameAnimFinished(scene) -> void:
	scene.queue_free()
	Transitioned.emit(self, "GameThrow")
	
func minigameFinished(scene) -> void:
	var incertancy : float = variationPercentage - scene.getScore() # x/10 of incertaincy
	ShowOnGaugeLabel(int((gauge.value * 100) / globalVars.maxSpeed), incertancy)
	var tenPercentOfPower : float = (variationPercentage * globalVars.maxSpeed) / 100 # 10% of max power
	incertancy = (incertancy * tenPercentOfPower) / variationPercentage
	var oldToastSpeed : float = globalVars.toastSpeed
	globalVars.toastSpeed = randf_range(oldToastSpeed - incertancy, oldToastSpeed + incertancy)
	
func ShowOnGaugeLabel(percentage: int, incertancy : float = 0) -> void:
	var newString : String = "[center]"
	if incertancy != 0:
		newString += '[shake rate=' + str(incertancy * 1.5) + ' level=' + str(5 + incertancy / 2) + ' connected=1]'
	newString += str(percentage) + '%'
	if incertancy != 0:
		newString += ' ±' + str(incertancy) + '[/shake]'
	newString += '[/center]'
	gaugeLabel.text = newString
