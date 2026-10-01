extends RigidBody2D


@export var frame: int
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite.frame = frame
