extends RigidBody2D
var toastTeam: int
var collision : KinematicCollision2D
signal toastCollision
signal toastTookButter
var acceleration : float = 1
var mold : float = 0
var canMold : bool = false
var crumbTextures : Array = []

@onready var Sprite : Sprite2D = $Icon
@onready var crumbScene = preload("res://Scenes/Scenes/crumb.tscn")

@export var collisionSound : AudioStream
@export var dieSound : AudioStream
@export var accelerationDecay : float
@export var diffSpawnCrumbX : float
@export var diffSpawnCrumbY : float
@export var offsetRotationCrumb : float
@export var TopLeftToast : Texture2D
@export var TopRightToast : Texture2D
@export var BottomLeftToast : Texture2D
@export var BottomRightToast : Texture2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	crumbTextures.append(BottomRightToast)
	crumbTextures.append(BottomLeftToast)
	crumbTextures.append(TopRightToast)
	crumbTextures.append(TopLeftToast)

func _process(delta: float) -> void:
	if mold >= 100:
		dieMakeCrumbs()

func _physics_process(delta: float) -> void:
	updateSprite()
	collision = move_and_collide(Vector2(0, 0), true)
	linear_velocity *= acceleration
	acceleration = lerp(acceleration, 1.0, accelerationDecay)

func updateSprite() -> void:
	if mold > 100:
		Sprite.frame = 5
	elif mold > 80:
		Sprite.frame = 4
	elif mold > 60:
		Sprite.frame = 3
	elif mold > 40:
		Sprite.frame = 2
	elif mold > 20:
		Sprite.frame = 1
	else:
		Sprite.frame = 0

func setTeam(team : int) -> void:
	toastTeam = team
	if team == 1:
		$Icon.material.set("shader_parameter/outline_color", Color("ff0000"))
	else:
		$Icon.material.set("shader_parameter/outline_color", Color("0000ff"))

func getTeam() -> int:
	return toastTeam

func sendToastTookButter() -> void:
	toastTookButter.emit(self)

func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if linear_velocity.length() > 150:
		if collision != null:
			var newPosition : Vector2 = collision.get_position()
			$GPUParticles2D.global_position = newPosition
		else:
			$GPUParticles2D.position = Vector2(0, 0)
		$GPUParticles2D.emitting = true
		toastCollision.emit(linear_velocity.length() / 7)
		AudioManager.playSound(collisionSound)
		
func dieMakeCrumbs() -> void:
	var crumbParent = get_parent().get_parent().get_node("Crumbs")
	mold = 0
	for i in range(4):
		var newCrumb := crumbScene.instantiate()
		var offset : Vector2 = Vector2(0,0)
		match i:
			0:
				offset.x += diffSpawnCrumbX
				offset.y += diffSpawnCrumbY
			1:
				offset.x -= diffSpawnCrumbX
				offset.y += diffSpawnCrumbY
			2:
				offset.x += diffSpawnCrumbX
				offset.y -= diffSpawnCrumbY
			3:
				offset.x -= diffSpawnCrumbX
				offset.y -= diffSpawnCrumbY
		newCrumb.setSprite(crumbTextures[i])
		newCrumb.position = self.position + offset
		newCrumb.linear_velocity = self.linear_velocity + (offset / 2)
		newCrumb.rotation_degrees = randf_range(-offsetRotationCrumb, offsetRotationCrumb)
		crumbParent.add_child(newCrumb)
	$GPUParticles2D.emitting = true
	linear_velocity = Vector2(0,0)
	position = Vector2(100000, 1000000)
	AudioManager.playSound(dieSound)
	
func addMold(amount : float) -> void:
	if canMold:
		mold += amount
