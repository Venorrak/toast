extends Resource
class_name Score

@export var username : String = ""
@export var score : int = 10000

func _init(name : String = "", Scored : int = 10000) -> void:
	username = name
	score = Scored
