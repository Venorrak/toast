extends Sprite2D
@export var animDuration : float = 1

@onready var timer = $Timer

var animColor : Color = Color("ffffff")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = animDuration


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer.time_left != 0:
		var darkenedValue = (animDuration - timer.time_left) / animDuration
		var darkerColor = animColor.darkened(darkenedValue)
		modulate = darkerColor


func startAnim(good : bool):
	if good:
		animColor = Color("00ff00")
	else:
		animColor = Color("ff0000")
	timer.start()

func _on_timer_timeout() -> void:
	modulate = Color("000000")
	animColor = Color("000000")
