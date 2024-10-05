extends Node2D
@onready var arrow = $Arrow
@onready var aim = $Arrow/Aim
@onready var toast = $toast
@onready var gauge = $Control/TextureProgressBar
@onready var gaugeLabel = $Control/RichTextLabel
@onready var target = $Target
@onready var camera = $Camera2D
@onready var progressBar = $HUD/ProgressBar
@onready var speedLabel = $HUD/speedLabel
@onready var HUD = $HUD

@export var rotationSpeed: float
@export var gaugeSpeed: float
@export var minSpeed: int
@export var maxSpeed: int
@export var maxZoomCamera: float
var toastSpeed: float = 1.0
var incertancy: float = 0.0
var QTEScene : PackedScene = preload("res://Scenes/Scenes/qte.tscn")
@onready var toastStartPosition: Vector2 = $toast.global_position

var variationPercentage : float = 10 #if you change don't forget to change in qte.gd too

enum gameState {DIRECTION, POWER, THROW, WAITING}
var state = gameState.DIRECTION

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gauge.min_value = minSpeed
	gauge.max_value = maxSpeed
	gauge.step = maxSpeed / 100
	gauge.visible = false
	gaugeLabel.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	updateCamera()
	if toast.linear_velocity.y > 0 && arrow.visible == true:
		arrow.visible = false
	
	speedLabel.text = str(toast.linear_velocity.length())
	
	if gaugeSpeed != 0:
		gauge.value += gaugeSpeed
		if gauge.value >= maxSpeed or gauge.value <= minSpeed:
			gaugeSpeed *= -1
		ShowOnGaugeLabel(int((gauge.value * 100) / maxSpeed))
	if rotationSpeed != 0:
		arrow.rotation_degrees += rotationSpeed
		if arrow.rotation_degrees >= 90 or arrow.rotation_degrees <= -90:
			rotationSpeed *= -1
	if Input.is_action_just_pressed("interact"):
		match state:
			gameState.DIRECTION:
				rotationSpeed = 0
				gauge.visible = true
				gaugeLabel.visible = true
				state = gameState.POWER
			gameState.THROW:
				var vector = getdirectionVector()
				vector *= toastSpeed
				toast.look_at(vector)
				toast.rotation += 90
				toast.linear_velocity = vector
				gauge.visible = false
				gaugeLabel.visible = false
				state = gameState.WAITING
			gameState.POWER:
				toastSpeed = gauge.value
				gaugeSpeed = 0
				var minigame = QTEScene.instantiate()
				minigame.connect("_minigame_finished", minigameFinished)
				HUD.add_child(minigame)
				state = gameState.WAITING

func getdirectionVector():
	var delta = aim.global_position - arrow.global_position
	return delta.normalized()
	
func minigameFinished(scene):
	incertancy = variationPercentage - scene.getScore()
	ShowOnGaugeLabel(int((gauge.value * 100) / maxSpeed), incertancy)
	var tenPercentOfPower = (variationPercentage * maxSpeed) / 100
	incertancy = (incertancy * tenPercentOfPower) / variationPercentage
	toastSpeed = randf_range(toastSpeed - incertancy, toastSpeed + incertancy)
	scene.queue_free()
	state = gameState.THROW

func ShowOnGaugeLabel(percentage: int, incertancy : float = 0) -> void:
	var newString = "[center]"
	if incertancy != 0:
		newString += '[shake rate=' + str(incertancy * 1.5) + ' level=' + str(5 + incertancy / 2) + ' connected=1]'
	newString += str(percentage) + '%'
	if incertancy != 0:
		newString += ' ±' + str(incertancy) + '[/shake]'
	newString += '[/center]'
	gaugeLabel.text = newString

func updateCamera():
	camera.position.y = toast.position.y
	if toast.position.y < target.position.y:
		camera.position.y = target.position.y
	if toast.position.y > toastStartPosition.y:
		camera.position.y = toastStartPosition.y
	var deltaPosToastTarget = target.position - toastStartPosition
	var middle = (deltaPosToastTarget.y / 2) + toastStartPosition.y
	var deltaToastMiddle = middle - toast.position.y
	var percent
	
	progressBar.setProgress((100 - ((target.position.y - toast.position.y) * 100) / deltaPosToastTarget.y))
	
	if deltaToastMiddle < 0:
		percent = ((toast.position.y - toastStartPosition.y) * 100) / (deltaPosToastTarget.y / 2)
		
	if deltaToastMiddle > 0:
		percent = 100 - ((toast.position.y - middle) * 100) / (deltaPosToastTarget.y / 2)
	
	if percent < 0:
		percent = 0
		
	#apply ease out
	percent = ease(percent / 100, 0.4) * 100
	
	var zoomValue = 1 - ((percent * (1 - maxZoomCamera)) / 100)
	camera.zoom = Vector2(zoomValue, zoomValue)
