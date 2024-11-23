extends Node2D
class_name World
@onready var toastHome = $Toasts
@onready var trailHome = $Trails
@onready var moldHome = $Molds
@onready var PadHome = $Pads
@onready var gauge = $HUD/Control/TextureProgressBar
@onready var camera = $mainCamera
@onready var anouncementLabel = $HUD/AnnouncementLabel
@onready var anouncementTimer = $HUD/AnnouncementLabel/Timer

const ToastScene : PackedScene = preload("res://Scenes/Scenes/toast.tscn") # a toast
const TrailScene : PackedScene = preload("res://Scenes/Scenes/trail.tscn") # butter trail of the toast
const BoostPadScene : PackedScene = preload("res://Scenes/Scenes/BoostPad.tscn") # BUTTER
const SlowPadScene : PackedScene = preload("res://Scenes/Scenes/SlowPad.tscn") # JAM
const PauseScene : PackedScene = preload("res://Scenes/Scenes/startMenu.tscn") # pause menu
const moldScene : PackedScene = preload("res://Scenes/Scenes/mold.tscn")

@export var trailFrequency : int = 5 # frequency in px at which the trail will create a new point
@export var globalShader : ColorRect
@export var noise : FastNoiseLite # noise used for random pads placement
@export_group("map params")
@export var nbOfBoost : int # number of boost pads
@export var nbOfSlow : int # number of slow pads
@export var nbOfMold : int # number of mold zones
@export var moldPosOffset : float

func _ready() -> void:
	globalVars.toastStartPosition = $Toaster.position
	gauge.min_value = 0
	gauge.max_value = globalVars.maxSpeed
	gauge.step = globalVars.maxSpeed / 100
	gauge.visible = false
	$HUD/Control/RichTextLabel.visible = false
	getCreateToast()
	SpawnPads()
	if globalVars.moldEnabled:
		SpawnMold()
	camera.make_current()
	randomize()
	noise.seed = int(randi() * 1000)

func _physics_process(delta: float) -> void:
	updateShaderPixelate()
	
	if anouncementTimer.time_left == 0:
		updateAnnouncementLabel()
	
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused == false:
			$HUD.add_child(PauseScene.instantiate())

func cameraShake(shake : float) -> void:
	camera.shake(shake)
	
func updateShaderPixelate() -> void:
	var currentCamera : Camera2D = get_viewport().get_camera_2d()
	var shaderVariance : float = 200
	var trueShader : ShaderMaterial = globalShader.material as ShaderMaterial
	trueShader.set_shader_parameter("resolution", (400 + inverse_lerp(1, 0.3, currentCamera.zoom.x) * shaderVariance))
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
	globalVars.currentToast = newToast
	createTrail(globalVars.toastStartPosition)
	globalVars.nbOfToasts -= 1

func createTrail(startPoint: Vector2) -> void:
	var newTrail = TrailScene.instantiate()
	newTrail.setInitialPoisition(startPoint)
	newTrail.setTrailToast(globalVars.currentToast)
	trailHome.add_child(newTrail)

func SpawnPads() -> void:
	var xs : Array = range(PadHome.nbOfColumns)
	var ys : Array = range(PadHome.nbOfRows)
	xs.shuffle()
	ys.shuffle()
	if globalVars.jamEnabled:
		for x in xs:
			for y in ys:
				if randf_range(0, 100) > 99 and nbOfSlow > 0 and not PadHome.isNearEnabledCell(Vector2(x,y)):
					var newSlow := SlowPadScene.instantiate()
					newSlow.position = PadHome.getCellCenterPosition(Vector2(x, y))
					PadHome.add_child(newSlow)
					PadHome.enableCell(Vector2(x, y))
					nbOfSlow -= 1
	
	if globalVars.butterEnabled:
		for x in xs:
			for y in ys:
				if randf_range(0, 100) > 99 and nbOfBoost > 0 and not PadHome.isNearEnabledCell(Vector2(x,y)):
					var newBoost := BoostPadScene.instantiate()
					newBoost.position = PadHome.getCellCenterPosition(Vector2(x, y))
					PadHome.add_child(newBoost)
					PadHome.enableCell(Vector2(x, y))
					nbOfBoost -= 1

func SpawnMold() -> void:
	var xs : Array = range(moldHome.nbOfColumns)
	var ys : Array = range(moldHome.nbOfRows)
	xs.shuffle()
	ys.shuffle()
	for x in xs:
		for y in ys:
			var offsetX : float = randf_range(-moldPosOffset, moldPosOffset)
			var offsetY : float = randf_range(-moldPosOffset, moldPosOffset)
			if moldHome.enabledCells.size() == 0 or nbOfMold > 0 and moldHome.numberEnabledInColumn(x) < 4 and moldHome.isNextToEnabled(Vector2(x,y)):
				var newMold := moldScene.instantiate()
				newMold.position = moldHome.getCellCenterPosition(Vector2(x, y))
				newMold.position += Vector2(offsetX, offsetY)
				newMold.rotation_degrees = randf_range(0, 360)
				moldHome.add_child(newMold)
				moldHome.enableCell(Vector2(x, y))
				nbOfMold -= 1
