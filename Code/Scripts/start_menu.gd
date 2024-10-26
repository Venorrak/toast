extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Restart.grab_focus()
	Engine.time_scale = 0.0

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		Engine.time_scale = 1.0
		queue_free()


func _on_main_menu_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/Scenes/main_menu.tscn")

func _on_restart_button_up() -> void:
	get_tree().reload_current_scene()

func _on_quit_button_up() -> void:
	get_tree().quit()
