extends RigidBody2D
var toastTeam: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setTeam(team : int) -> void:
	toastTeam = team
	if team == 1:
		$Icon.material.set("shader_parameter/outline_color", Color("ff0000"))
	else:
		$Icon.material.set("shader_parameter/outline_color", Color("0000ff"))

func getTeam() -> int:
	return toastTeam
	
