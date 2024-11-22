extends AudioStreamPlayer

func playSound(sound : AudioStream) -> void:
	stream = sound
	play()

func setVolume(newVolume : float) -> void:
	volume_db = linear_to_db(newVolume)
	
func getVolume() -> float:
	return db_to_linear(volume_db)
