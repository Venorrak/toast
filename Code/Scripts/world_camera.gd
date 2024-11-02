extends Camera2D

@export var camera : Camera2D

@onready var worldCameraFinalPosition : Vector2 = position
@onready var worldCameraFinalZoom : Vector2 = zoom

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("altView"):
		make_current()
	
	if !Input.is_action_pressed("altView"):
		if areVecEqual(camera.global_position, global_position, 0.005) and areVecEqual(camera.zoom, zoom, 0.005) and is_current():
			camera.make_current()
		position = lerp(position, camera.position, 0.4)
		zoom = lerp(zoom, camera.zoom, 0.1)
		
	if Input.is_action_pressed("altView"):
		position = lerp(position, worldCameraFinalPosition, 0.4)
		zoom = lerp(zoom, worldCameraFinalZoom, 0.1)	
	
func areVecEqual(vec1 : Vector2, vec2 : Vector2, incertaincy : float) -> bool:
	if vec1.x - vec2.x < incertaincy:
		if vec1.y - vec2.y < incertaincy:
			return true
	return false
