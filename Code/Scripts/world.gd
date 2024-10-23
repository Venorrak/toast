extends Node2D
@onready var toaster = $Toaster
@onready var aim = $Toaster/Aim
@onready var toastHome = $Toasts
@onready var trailHome = $Trails
@onready var gauge = $Control/TextureProgressBar
@onready var gaugeLabel = $Control/RichTextLabel
@onready var target = $Target
@onready var camera = $Camera2D
@onready var progressBar = $HUD/ProgressBar
@onready var speedLabel = $HUD/speedLabel
@onready var HUD = $HUD

@onready var toastStartPosition: Vector2 = $Toaster.position #position of toast at the start of the game

var toast # current toast being controlled / followed
var nbOfToasts = 6 # total number of toast for the game
var rotationSpeed: float # current rotation speed of toaster
var gaugeSpeed: float # current speed of power gauge
var toastSpeed: float = 1.0 # speed the toast is gonna be thrown at
var incertancy: float = 0.0 # incertancy in % of the power output
enum gameState {DIRECTION, POWER, THROW, WAITING, THROWN} # states of a toast, repeated (nbOfToasts) times
var state = gameState.DIRECTION # start with choosing direction
var variationPercentage : float = 10 # max variation of the power output. if you change don't forget to change in qte.gd too
var gameEnded : bool = false

var QTEScene : PackedScene = preload("res://Scenes/Scenes/qte.tscn") # guitart hero
var ToastScene : PackedScene = preload("res://Scenes/Scenes/toast.tscn") # a toast
var ResultsScene : PackedScene = preload("res://Scenes/Scenes/resultsScreen.tscn") # result screen
var TrailScene : PackedScene = preload("res://Scenes/Scenes/trail.tscn") # butter trail of the toast

@export var ValidToastDistance: float # maximum distance from the target where the toast is valid / doesn't dissapear
@export var rotationSpeedInit: float # rotation speed of toaster at start
@export var gaugeSpeedInit: float # speed of power gauge at start 
@export var minSpeed: int # minimum speed of gauge and toast
@export var maxSpeed: int # maximum speed of gauge and toast
@export var maxZoomCamera: float # max UNzoom of the camera
@export var trailFrequency : int = 5 # frequency in px at which the trail will create a new point

func _ready() -> void:
	rotationSpeed = rotationSpeedInit
	gaugeSpeed = gaugeSpeedInit
	gauge.min_value = minSpeed
	gauge.max_value = maxSpeed
	gauge.step = maxSpeed / 100
	gauge.visible = false
	gaugeLabel.visible = false
	getCreateToast()

func _physics_process(delta: float) -> void:
	updateTrails()
	updateCamera()
	updateGauge()
	updateToaster()
	
	#make toaster invisible if the toast goes back down
	if toast.linear_velocity.y > 0 && toaster.visible == true:
		toaster.visible = false
	
	#speedLabel.text = str(toast.linear_velocity.length())
	
	if toast.linear_velocity.length() < 3 and state == gameState.THROWN:
		#if the toast is further than the valid distance from the target
		if (toast.global_position - target.global_position).length() > ValidToastDistance:
			toast.position = Vector2(100000, 1000000) # no queue_free because of result screen resons
		
		#if the game is not finished
		if nbOfToasts > 0:
			getCreateToast()
			toaster.visible = true
			rotationSpeed = rotationSpeedInit
			gaugeSpeed = gaugeSpeedInit
			state = gameState.DIRECTION
		
		# else the game is finished
		else:
			if gameEnded == false:
				gameEnded = true
				gameEnding()
	
	if Input.is_action_just_pressed("interact"):
		InteractInput()

func gameEnding() -> void:
	var redTeamScore : Array = []
	var blueTeamScore : Array = []
	var redTeamScoreTotal : int = 0
	var blueTeamScoreTotal : int = 0
	
	for toast in toastHome.get_children():
		var toastScore = int((toast.global_position - target.global_position).length())
		if toast.getTeam() == 0:
			if toastScore > ValidToastDistance:
				blueTeamScore.append(ValidToastDistance)
			else:
				blueTeamScore.append(toastScore)
			blueTeamScoreTotal += blueTeamScore[-1]
		else:
			if toastScore > ValidToastDistance:
				redTeamScore.append(ValidToastDistance)
			else:
				redTeamScore.append(toastScore)
			redTeamScoreTotal += redTeamScore[-1]
	redTeamScore.append(redTeamScoreTotal)
	blueTeamScore.append(blueTeamScoreTotal)
	
	var newResultScene = ResultsScene.instantiate()
	newResultScene.updateBlueScore(blueTeamScore)
	newResultScene.updateRedScore(redTeamScore)
	HUD.add_child(newResultScene)

func InteractInput() -> void:
	match state:
			gameState.DIRECTION:
				rotationSpeed = 0
				gauge.visible = true
				gaugeLabel.visible = true
				state = gameState.POWER
				
			gameState.THROW:
				var direction : Vector2 = toastSpeed * getThrowDirection()
				toast.look_at(direction + toast.global_position)
				toast.linear_velocity = direction
				gauge.visible = false
				gaugeLabel.visible = false
				state = gameState.THROWN
				
			gameState.POWER:
				toastSpeed = gauge.value
				gaugeSpeed = 0
				var minigame = QTEScene.instantiate()
				minigame.connect("_minigame_finished", minigameFinished)
				minigame.connect("_animation_finished", minigameAnimFinished)
				HUD.add_child(minigame)
				state = gameState.WAITING

func getThrowDirection() -> Vector2:
	var delta : Vector2 = aim.global_position - toaster.global_position
	return delta.normalized()
	
func minigameFinished(scene) -> void:
	incertancy = variationPercentage - scene.getScore() # x/10 of incertaincy
	ShowOnGaugeLabel(int((gauge.value * 100) / maxSpeed), incertancy)
	var tenPercentOfPower : float = (variationPercentage * maxSpeed) / 100 # 10% of max power
	incertancy = (incertancy * tenPercentOfPower) / variationPercentage
	toastSpeed = randf_range(toastSpeed - incertancy, toastSpeed + incertancy)

func minigameAnimFinished(scene) -> void:
	scene.queue_free()
	state = gameState.THROW

func ShowOnGaugeLabel(percentage: int, incertancy : float = 0) -> void:
	var newString : String = "[center]"
	if incertancy != 0:
		newString += '[shake rate=' + str(incertancy * 1.5) + ' level=' + str(5 + incertancy / 2) + ' connected=1]'
	newString += str(percentage) + '%'
	if incertancy != 0:
		newString += ' ±' + str(incertancy) + '[/shake]'
	newString += '[/center]'
	gaugeLabel.text = newString

func updateToaster() -> void:
	if rotationSpeed != 0:
		toaster.rotation_degrees += rotationSpeed
		if toaster.rotation_degrees >= 90 or toaster.rotation_degrees <= -90:
			rotationSpeed *= -1

func updateGauge() -> void:
	if gaugeSpeed != 0:
		gauge.value += gaugeSpeed
		if gauge.value >= maxSpeed or gauge.value <= minSpeed:
			gaugeSpeed *= -1
		ShowOnGaugeLabel(int((gauge.value * 100) / maxSpeed))
	
	var deltaPosToastTargetY : float = target.position.y - toastStartPosition.y
	progressBar.setProgress((100 - ((target.position.y - toast.position.y) * 100) / deltaPosToastTargetY))

func updateCamera() -> void:
	camera.position.y = toast.position.y
	if toast.position.y < target.position.y:
		camera.position.y = target.position.y
	if toast.position.y > toastStartPosition.y:
		camera.position.y = toastStartPosition.y
	var deltaPosToastTargetY : float = target.position.y - toastStartPosition.y
	var middle = (deltaPosToastTargetY / 2) + toastStartPosition.y
	var deltaToastMiddle = middle - toast.position.y
	var percent
	
	if deltaToastMiddle < 0:
		percent = ((toast.position.y - toastStartPosition.y) * 100) / (deltaPosToastTargetY / 2)
		
	if deltaToastMiddle > 0:
		percent = 100 - ((toast.position.y - middle) * 100) / (deltaPosToastTargetY / 2)
	
	if percent < 0:
		percent = 0
		
	#apply ease out
	percent = ease(percent / 100, 0.4) * 100
	
	var zoomValue : float = 1 - ((percent * (1 - maxZoomCamera)) / 100)
	camera.zoom = Vector2(zoomValue, zoomValue)

func getCreateToast() -> void:
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
	var allToasts : Array = toastHome.get_children()
	var allTrails : Array = trailHome.get_children()
	for i in allToasts.size():
		if (allToasts[i].global_position - target.global_position).length() < 10000:
			if (allToasts[i].global_position - allTrails[i].points[-1]).length() > 5:
				allTrails[i].add_point(allToasts[i].global_position)
