extends Node
class_name BaseState

# Signal pour annoncer un changement d’état
signal Transitioned

func handle_inputs() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass

func enter() -> void:
	pass

func exit() -> void:
	pass
