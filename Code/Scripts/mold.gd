extends Sprite2D

var toastsInMold : Array = []
@export var moldAppliedOnEnter : float
@export var moldAppliedOnTimout : float

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("toast"):
		toastsInMold.append(body)
		body.addMold(moldAppliedOnEnter)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("toast"):
		toastsInMold.erase(body)


func _on_timer_timeout() -> void:
	for toast in toastsInMold:
		toast.addMold(moldAppliedOnTimout)
