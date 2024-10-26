extends RigidBody2D
var toastTeam: int
var collision : KinematicCollision2D
signal toastCollision
var acceleration : float = 1

@export var accelerationDecay : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	collision = move_and_collide(Vector2(0, 0), true)
	linear_velocity *= acceleration
	acceleration = lerp(acceleration, 1.0, accelerationDecay)

func setTeam(team : int) -> void:
	toastTeam = team
	if team == 1:
		$Icon.material.set("shader_parameter/outline_color", Color("ff0000"))
	else:
		$Icon.material.set("shader_parameter/outline_color", Color("0000ff"))

func getTeam() -> int:
	return toastTeam
	


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if linear_velocity.length() > 150:
		if collision != null:
			var newPosition : Vector2 = collision.get_position()
			$GPUParticles2D.global_position = newPosition
		else:
			$GPUParticles2D.position = Vector2(0, 0)
		$GPUParticles2D.emitting = true
		toastCollision.emit(linear_velocity.length() / 7)
