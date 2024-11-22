extends RigidBody2D

@onready var sprite : Sprite2D = $Sprite2D

@export var onSpawnSprite : Texture2D

func setSprite(texture : Texture2D) -> void:
	onSpawnSprite = texture
	
func _ready() -> void:
	sprite.texture = onSpawnSprite
