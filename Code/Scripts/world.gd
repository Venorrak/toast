extends Node2D
@onready var arrow = $Arrow
@onready var aim = $Arrow/Aim
var toast
@export var ValidToastDistance: float
var nbOfToasts = 6
@onready var toastHome = $Toasts
@onready var trailHome = $Trails
@onready var gauge = $Control/TextureProgressBar
@onready var gaugeLabel = $Control/RichTextLabel
@onready var target = $Target
@onready var camera = $Camera2D
@onready var progressBar = $HUD/ProgressBar
@onready var speedLabel = $HUD/speedLabel
@onready var HUD = $HUD


@export var rotationSpeedInit: float
@export var gaugeSpeedInit: float
var rotationSpeed: float
var gaugeSpeed: float
@export var minSpeed: int
@export var maxSpeed: int
@export var maxZoomCamera: float
var toastSpeed: float = 1.0
var incertancy: float = 0.0
var QTEScene : PackedScene = preload("res://Scenes/Scenes/qte.tscn")
var ToastScene : PackedScene = preload("res://Scenes/Scenes/toast.tscn")
var ResultsScene : PackedScene = preload("res://Scenes/Scenes/resultsScreen.tscn")
var TrailScene : PackedScene = preload("res://Scenes/Scenes/trail.tscn")
@onready var toastStartPosition: Vector2 = $Arrow.position

var variationPercentage : float = 10 #if you change don't forget to change in qte.gd too

enum gameState {DIRECTION, POWER, THROW, WAITING}
var state = gameState.DIRECTION

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotationSpeed = rotationSpeedInit
	gaugeSpeed = gaugeSpeedInit
	gauge.min_value = minSpeed
	gauge.max_value = maxSpeed
	gauge.step = maxSpeed / 100
	gauge.visible = false
	gaugeLabel.visible = false
	getCreateToast()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	updateTrails()
	updateCamera()
	if toast.linear_velocity.y > 0 && arrow.visible == true:
		arrow.visible = false
	
	speedLabel.text = str(toast.linear_velocity.length())
	if toast.linear_velocity.length() < 3 and toast.linear_velocity.length() > 1:
		if (toast.global_position - target.global_position).length() > ValidToastDistance:
			toast.position = Vector2(100000, 1000000)
		if nbOfToasts > 0:
			getCreateToast()
			arrow.visible = true
			rotationSpeed = rotationSpeedInit
			gaugeSpeed = gaugeSpeedInit
			state = gameState.DIRECTION
		else:
			var redTeamScore : Array = []
			var blueTeamScore : Array = []
			for toast in toastHome.get_children():
				var toastScore = int((toast.global_position - target.global_position).length())
				if toast.getTeam() == 0:
					if toastScore > ValidToastDistance:
						blueTeamScore.append(ValidToastDistance)
					else:
						blueTeamScore.append(toastScore)
				else:
					if toastScore > ValidToastDistance:
						redTeamScore.append(ValidToastDistance)
					else:
						redTeamScore.append(toastScore)
			var redTeamScoreTotal = 0
			var blueTeamScoreTotal = 0
			for scr in redTeamScore:
				redTeamScoreTotal += scr
			for scr in blueTeamScore:
				blueTeamScoreTotal += scr
			redTeamScore.append(redTeamScoreTotal)
			blueTeamScore.append(blueTeamScoreTotal)
			var newResultScene = ResultsScene.instantiate()
			newResultScene.updateBlueScore(blueTeamScore)
			newResultScene.updateRedScore(redTeamScore)
			HUD.add_child(newResultScene)
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

func getCreateToast():
	var newToast = ToastScene.instantiate()
	newToast.position = toastStartPosition
	newToast.setTeam(nbOfToasts % 2 == 0)
	toastHome.add_child(newToast)
	createTrail(toastStartPosition)
	toast = newToast
	nbOfToasts -= 1

func createTrail(startPoint: Vector2) -> void:
	var newTrail = TrailScene.instantiate()
	newTrail.add_point(startPoint)
	trailHome.add_child(newTrail)

func updateTrails() -> void:
	var allToasts = toastHome.get_children()
	var allTrails = trailHome.get_children()
	for i in allToasts.size():
		if (allToasts[i].global_position - allTrails[i].points[-1]).length() > 5:
			allTrails[i].add_point(allToasts[i].global_position)
