extends Sprite2D
var speed = Vector2(0,0)
var type: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += speed

func setSpeed(sped: float):
	speed.y = sped

func setType(newType: String):
	type = newType
	
func getType():
	return type
