extends Node2D
@onready var top : Line2D = $top
@onready var bottom : Line2D = $bottom
@onready var center : Line2D = $center
@onready var status : Sprite2D = $status
var deltaTopBottom
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deltaTopBottom = bottom.points[0].y - top.points[0].y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass

func setProgress(percent: float):
	var height = (deltaTopBottom * (100 - percent)) / 100
	status.position.y = height
