extends Node
var volume : float

func playSound(sound : AudioStream) -> void:
	var instance = AudioStreamPlayer.new()
	instance.stream = sound
	instance.play()

func setVolume(newVolume : float) -> void:
	volume = linear_to_db(newVolume)
	
func getVolume() -> void:
	return db_to_linear(volume)
