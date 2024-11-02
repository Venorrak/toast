extends Camera2D

@export var target : Sprite2D
@export_range(0, 1, 0.05) var maxZoomCamera: float # max UNzoom of the camera
@export_range(0, 1, 0.05) var SHAKE_DECAY_RATE : float # rate at which the shake slows down

var shakeStrength : float # strenght of shake

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.y = globalVars.currentToast.position.y
	if globalVars.currentToast.position.y < target.position.y:
		position.y = target.position.y
	if globalVars.currentToast.position.y > globalVars.toastStartPosition.y:
		position.y = globalVars.toastStartPosition.y
	var deltaPosToastTargetY : float = target.position.y - globalVars.toastStartPosition.y
	var middle : float = (deltaPosToastTargetY / 2) + globalVars.toastStartPosition.y
	var deltaToastMiddle : float = middle - globalVars.currentToast.position.y
	var percent : float
	
	if deltaToastMiddle < 0:
		percent = ((globalVars.currentToast.position.y - globalVars.toastStartPosition.y) * 100) / (deltaPosToastTargetY / 2)
		
	if deltaToastMiddle > 0:
		percent = 100 - ((globalVars.currentToast.position.y - middle) * 100) / (deltaPosToastTargetY / 2)
	
	if percent < 0:
		percent = 0
		
	#apply ease out
	percent = ease(percent / 100, 0.4) * 100
	
	var zoomValue : float = 1 - ((percent * (1 - maxZoomCamera)) / 100)
	zoom = Vector2(zoomValue, zoomValue)
	
	# camera shake part
	shakeStrength = lerp(shakeStrength, 0.0, SHAKE_DECAY_RATE)
	offset = Vector2(
		randf_range(-shakeStrength, shakeStrength),
		randf_range(-shakeStrength, shakeStrength)
	)	
	
func shake(shakeOutput: float) -> void:
	shakeStrength = shakeOutput
