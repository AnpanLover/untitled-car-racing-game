extends RigidBody2D


@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	var random = RandomNumberGenerator.new().randi_range(0, 3)
	sprite.frame = random
