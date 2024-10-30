extends Node

func _process(delta: float) -> void:
	manage_end_game()

func is_on_arcade() -> bool:
	return OS.get_executable_path().to_lower().contains("retropie")

func manage_end_game() -> void:
	if is_on_arcade() :
		if Input.is_action_pressed("hotkey") and Input.is_action_pressed("pause"):
			get_tree().quit()
