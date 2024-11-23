extends Node
class_name GlobalVars

var toastSpeed: float = 1.0 # speed the toast is gonna be thrown at
var gaugeSpeed: float = 12 # current speed of power gauge
var rotationSpeed: float = 3 # current rotation speed of toaster
const rotationSpeedInit: float = 3 # rotation speed of toaster at start
const gaugeSpeedInit: float = 12 # speed of power gauge at start 
var currentToast : RigidBody2D
const ValidToastDistance: float = 750 # maximum distance from the target where the toast is valid / doesn't dissapear
var nbOfToasts : int = 6 # total number of toast for the game
var toastStartPosition: Vector2
const maxSpeed: int = 1500 # maximum speed of gauge and toast
const variationPowerPercentage : float = 20
var miniGameEnabled : bool = true
var butterEnabled : bool = true
var jamEnabled : bool = true
var moldEnabled : bool = true


func reset() -> void:
	toastSpeed = 1.0
	gaugeSpeed= 12
	rotationSpeed = 3
	nbOfToasts = 6

func resetLevelParams() -> void:
	miniGameEnabled = true
	butterEnabled = true
	jamEnabled = true
	moldEnabled = true
	
