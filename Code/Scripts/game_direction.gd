extends BaseState
class_name GameDirection

@export var thisWorld : World
@export var gauge: TextureProgressBar
@export var gaugeLabel : RichTextLabel
@export var toaster : Sprite2D
@export var infoLabel : Label

func handle_inputs() -> void:
	if Input.is_action_just_pressed("interact"):
		globalVars.rotationSpeed = 0
		gauge.visible = true
		gaugeLabel.visible = true
		Transitioned.emit(self, "GamePower")

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	handle_inputs()
	if globalVars.rotationSpeed != 0:
		toaster.rotation_degrees += globalVars.rotationSpeed
		if toaster.rotation_degrees >= 90 or toaster.rotation_degrees <= -90:
			globalVars.rotationSpeed *= -1

func enter() -> void:
	DisplayInfo()

func exit() -> void:
	pass

func DisplayInfo() -> void:
	if arcadeManager.is_on_arcade():
		infoLabel.text = "Press A to choose toaster direction"
	else:
		infoLabel.text = "Press E to choose toaster direction"
	
