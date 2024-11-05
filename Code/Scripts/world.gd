extends Node2D
class_name World
@onready var toastHome = $Toasts
@onready var trailHome = $Trails
@onready var PadHome = $Pads
@onready var gauge = $Control/TextureProgressBar
@onready var camera = $mainCamera
@onready var anouncementLabel = $HUD/AnnouncementLabel
@onready var anouncementTimer = $HUD/AnnouncementLabel/Timer

const ToastScene : PackedScene = preload("res://Scenes/Scenes/toast.tscn") # a toast
const TrailScene : PackedScene = preload("res://Scenes/Scenes/trail.tscn") # butter trail of the toast
const BoostPadScene : PackedScene = preload("res://Scenes/Scenes/BoostPad.tscn") # BUTTER
const SlowPadScene : PackedScene = preload("res://Scenes/Scenes/SlowPad.tscn") # JAM
const PauseScene : PackedScene = preload("res://Scenes/Scenes/startMenu.tscn") # pause menu

@export var trailFrequency : int = 5 # frequency in px at which the trail will create a new point
@export var noise : FastNoiseLite # noise used for random pads placement
@export_group("map params")
@export var nbOfBoost : int # number of boost pads
@export var nbOfSlow : int # number of slow pads

func _ready() -> void:
	globalVars.toastStartPosition = $Toaster.position
	gauge.min_value = 0
	gauge.max_value = globalVars.maxSpeed
	gauge.step = globalVars.maxSpeed / 100
	gauge.visible = false
	$Control/RichTextLabel.visible = false
	getCreateToast()
	SpawnPads()
	camera.make_current()
	randomize()
	noise.seed = int(randi() * 1000)

func _physics_process(delta: float) -> void:
	updateTrails()
	
	if anouncementTimer.time_left == 0:
		updateAnnouncementLabel()
	
	if Input.is_action_just_pressed("pause"):
		if Engine.time_scale != 0.0:
			$HUD.add_child(PauseScene.instantiate())

func cameraShake(shake : float) -> void:
	camera.shake(shake)
	
#UI functions

func ShowOnAnnouncementLabel(text : String, fontSize : int, color : Color = Color("#FFFFFF"), visibleTime : float = 3.0) -> void:
	anouncementLabel.modulate = Color("#FFFFFF", 1)
	anouncementTimer.start(visibleTime)
	var newString : String = "[center][font_size=" + str(fontSize) + "][color=" + str(color.to_html(false)) + "]"
	newString += text
	newString += "[/color][/font_size][/center]"
	anouncementLabel.text = newString

func updateAnnouncementLabel() -> void:
	var lastColor : Color = anouncementLabel.modulate
	var newAlpha = lerp(lastColor.a, 0.0, 0.2)
	lastColor.a = newAlpha
	anouncementLabel.modulate = lastColor

# creation functions
func getCreateToast() -> void:
	var newToast = ToastScene.instantiate()
	newToast.position = globalVars.toastStartPosition
	newToast.setTeam(globalVars.nbOfToasts % 2 == 0)
	if globalVars.nbOfToasts % 2 == 0 :
		ShowOnAnnouncementLabel("Red Team", 90, Color("#FF0000"))
	else:
		ShowOnAnnouncementLabel("Blue Team", 90, Color("#0000FF"))
	newToast.connect("toastCollision", cameraShake)
	toastHome.add_child(newToast)
	createTrail(globalVars.toastStartPosition)
	globalVars.currentToast = newToast
	globalVars.nbOfToasts -= 1

func createTrail(startPoint: Vector2) -> void:
	var newTrail = TrailScene.instantiate()
	newTrail.add_point(startPoint)
	trailHome.add_child(newTrail)

func updateTrails() -> void:
	var allToasts : Array = toastHome.get_children()
	var allTrails : Array = trailHome.get_children()
	for i in allToasts.size():
		if (allToasts[i].global_position - $Target.global_position).length() < 10000:
			if (allToasts[i].global_position - allTrails[i].points[-1]).length() > 5:
				allTrails[i].add_point(allToasts[i].global_position)

func SpawnPads() -> void:
	var leftBound : float = $LeftWall/CollisionShape2D.global_position.x + 40
	var rightBound : float = $RightWall/CollisionShape2D.global_position.x - 40
	var topBound : float = $TopWall/CollisionShape2D.global_position.y + 30
	var downBound : float = $Toaster.global_position.y - 50
	for i in nbOfBoost:
		var newBoost = BoostPadScene.instantiate()
		var xPos : float = (noise.get_noise_1d(randf_range(0, 100000)) + 1) / 2 
		var yPos : float = (noise.get_noise_1d(randf_range(0, 100000)) + 1) / 2
		newBoost.global_position = Vector2(
			lerp(leftBound, rightBound, xPos),
			lerp(topBound, downBound, yPos)
		)
		PadHome.add_child(newBoost)
	
	for i in nbOfSlow:
		var newSlow = SlowPadScene.instantiate()
		var xPos : float = (noise.get_noise_1d(randf_range(0, 100000)) + 1) / 2 
		var yPos : float = (noise.get_noise_1d(randf_range(0, 100000)) + 1) / 2 
		newSlow.global_position = Vector2(
			lerp(leftBound, rightBound, xPos),
			lerp(topBound, downBound, yPos)
		)
		PadHome.add_child(newSlow)
