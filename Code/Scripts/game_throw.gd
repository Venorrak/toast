extends BaseState
class_name GameThrow

@export var thisWorld : World
@export var toaster : Sprite2D
@export var gauge : TextureProgressBar
@export var gaugeLabel : RichTextLabel
@export var infoLabel : Label

func handle_inputs() -> void:
	if Input.is_action_just_pressed("interact"):
		var direction : Vector2 = globalVars.toastSpeed * getThrowDirection()
		globalVars.currentToast.look_at(direction + globalVars.currentToast.global_position)
		globalVars.currentToast.linear_velocity = direction
		gauge.visible = false
		gaugeLabel.visible = false
		Transitioned.emit(self, "GameThrown")

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	handle_inputs()

func enter() -> void:
	DisplayInfo()

func exit() -> void:
	pass
	
func getThrowDirection() -> Vector2:
	var delta : Vector2 = toaster.get_child(0).global_position - toaster.global_position
	return delta.normalized()
	
func DisplayInfo() -> void:
	if arcadeManager.is_on_arcade():
		infoLabel.text = "Press A to throw the toast"
	else:
		infoLabel.text = "Press E to throw the toast"
