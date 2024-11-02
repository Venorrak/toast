extends BaseState
class_name GameWaiting

@export var thisWorld : World

func handle_inputs() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	handle_inputs()

func enter() -> void:
	pass

func exit() -> void:
	pass
