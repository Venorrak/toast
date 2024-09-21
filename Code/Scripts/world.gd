extends Node2D
@onready var arrow = $Arrow
@onready var aim = $Arrow/Aim
@onready var toast = $RigidBody2D
@onready var progress = $Control/TextureProgressBar
@export var rotationSpeed: float
@export var gaugeSpeed: float
@export var minSpeed: int
@export var maxSpeed: int
var toastSpeed: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress.min_value = minSpeed
	progress.max_value = maxSpeed
	progress.step = maxSpeed / 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if gaugeSpeed != 0:
		progress.value += gaugeSpeed
		if progress.value >= maxSpeed or progress.value <= minSpeed:
			gaugeSpeed *= -1
	if rotationSpeed != 0:
		arrow.rotation_degrees += rotationSpeed
		if arrow.rotation_degrees >= 90 or arrow.rotation_degrees <= -90:
			rotationSpeed *= -1
	if Input.is_action_just_pressed("stopArrow"):
		rotationSpeed = 0
	if Input.is_action_just_pressed("throw"):
		var vector = getdirectionVector()
		vector *= toastSpeed
		toast.linear_velocity = vector
	if Input.is_action_just_pressed("stopGauge"):
		toastSpeed = progress.value
		gaugeSpeed = 0

func getdirectionVector():
	var delta = aim.global_position - arrow.global_position
	return delta.normalized()
