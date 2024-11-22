extends Control
signal restartGame

@export var buttonSound : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Restart.grab_focus()
	get_tree().paused = true

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		AudioManager.playSound(buttonSound)
	
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = false
		queue_free()


func _on_main_menu_button_up() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Scenes/main_menu.tscn")

func _on_restart_button_up() -> void:
	get_tree().paused = false
	globalVars.reset()
	get_tree().reload_current_scene()

func _on_quit_button_up() -> void:
	get_tree().quit()
