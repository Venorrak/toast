extends BaseState
class_name GamePower

@export var thisWorld : World
@export var HUD : CanvasLayer
@export var gauge : TextureProgressBar
@export var target : Sprite2D
@export var gaugeLabel : RichTextLabel
@export var infoLabel : Label

var variationPercentage : float = 10 # max variation of the power output. if you change don't forget to change in qte.gd too

var QTEScene : PackedScene = preload("res://Scenes/Scenes/qte.tscn")


func handle_inputs() -> void:
	if Input.is_action_just_pressed("interact"):
		globalVars.toastSpeed = gauge.value
		globalVars.gaugeSpeed = 0
		if globalVars.miniGameEnabled:
			var minigame = QTEScene.instantiate()
			minigame.connect("_minigame_finished", minigameFinished)
			minigame.connect("_animation_finished", minigameAnimFinished)
			HUD.add_child(minigame)
			Transitioned.emit(self, "GameWaiting")
		else:
			Transitioned.emit(self, "GameThrow")

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
	DisplayInfo()

func exit() -> void:
	infoLabel.text = ""
	
func minigameAnimFinished(scene) -> void:
	scene.queue_free()
	Transitioned.emit(self, "GameThrow")
	
func minigameFinished(scene) -> void:
	var incertancy : float = globalVars.variationPowerPercentage - scene.getScore() # x/10 of incertaincy
	ShowOnGaugeLabel(int((gauge.value * 100) / globalVars.maxSpeed), incertancy)
	var PercentOfPower : float = (globalVars.variationPowerPercentage * globalVars.maxSpeed) / 100 # 10% of max power
	incertancy = (incertancy * PercentOfPower) / globalVars.variationPowerPercentage
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

func DisplayInfo() -> void:
	if arcadeManager.is_on_arcade():
		infoLabel.text = "Press A to choose the power output of the toaster"
	else:
		infoLabel.text = "Press E to choose the power output of the toaster"
