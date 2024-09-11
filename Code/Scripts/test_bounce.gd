extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var v_x = randf_range(50, 150)
	var v_y = 200 - v_x
	if randf_range(-1, 1) < 0:
		v_x = v_x * -1 
	if randf_range(-1, 1) < 0:
		v_y = v_y * -1
	linear_velocity = Vector2(v_x, v_y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
