extends Control
@export var buttonSound : AudioStream

@export var volumeSlider : HSlider
@export var playButton : TextureButton
@export var leaderboardButton : TextureButton
@export var optionsButton : TextureButton
@export var quitButton : TextureButton
@export var howToBackButton : TextureButton
@export var miniGameCheck : CheckButton
@export var butterCheck : CheckButton
@export var jamCheck : CheckButton
@export var moldCheck : CheckButton

@export var mainMenu : Control
@export var playMenu : Control
@export var optionsMenu : Control
@export var howToMenu : Control

func _ready() -> void:
	playButton.grab_focus()
	volumeSlider.value = AudioManager.getVolume()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		AudioManager.playSound(buttonSound)

func saveLevelParams() -> void:
	globalVars.miniGameEnabled = miniGameCheck.button_pressed
	globalVars.butterEnabled = butterCheck.button_pressed
	globalVars.jamEnabled = jamCheck.button_pressed
	globalVars.moldEnabled = moldCheck.button_pressed

func _on_play_button_button_up() -> void:
	playMenu.visible = true
	mainMenu.visible = false
	changeEnabledButtons(false)
	miniGameCheck.grab_focus()

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

func _on_play_fr_button_button_up() -> void:
	globalVars.reset()
	saveLevelParams()
	get_tree().change_scene_to_file("res://Scenes/Scenes/world.tscn")

func _on_back_button_button_up() -> void:
	playMenu.visible = false
	mainMenu.visible = true
	playButton.grab_focus()
	changeEnabledButtons(true)

func _on_how_to_button_button_up() -> void:
	howToMenu.visible = true
	mainMenu.visible = false
	changeEnabledButtons(false)
	howToBackButton.grab_focus()

func _on_back_button_how_button_up() -> void:
	howToMenu.visible = false
	mainMenu.visible = true
	playButton.grab_focus()
	changeEnabledButtons(true)
