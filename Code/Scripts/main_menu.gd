extends Control
@export var buttonSound : AudioStream
@export var playButton : TextureButton
@export var leaderboardButton : TextureButton
@export var optionsButton : TextureButton
@export var quitButton : TextureButton
@export var mainMenu : Control
@export var optionsMenu : Control
@export var volumeSlider : HSlider

func _ready() -> void:
	playButton.grab_focus()
	volumeSlider.value = AudioManager.getVolume()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		AudioManager.playSound(buttonSound)

func _on_play_button_button_up() -> void:
	globalVars.reset()
	get_tree().change_scene_to_file("res://Scenes/Scenes/world.tscn")

func _on_options_button_button_up() -> void:
	optionsMenu.visible = true
	mainMenu.visible = false
	changeEnabledButtons(false)
	volumeSlider.grab_focus()

func _on_quit_button_button_up() -> void:
	get_tree().quit()

func _on_leaderboard_button_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/Scenes/leaderboardMenu.tscn")

func _on_texture_button_button_up() -> void:
	optionsMenu.visible = false
	mainMenu.visible = true
	playButton.grab_focus()
	changeEnabledButtons(true)
	
func changeEnabledButtons(enable : bool) -> void:
	playButton.disabled = not enable
	leaderboardButton.disabled = not enable
	optionsButton.disabled = not enable
	quitButton.disabled = not enable

func _on_h_slider_value_changed(value: float) -> void:
	AudioManager.setVolume(value)
