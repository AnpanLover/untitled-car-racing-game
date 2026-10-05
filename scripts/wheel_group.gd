extends Node2D


func _ready() -> void:
	var random = RandomNumberGenerator.new().randi_range(0, 3)
	var childs = get_children()
	
	for child in childs:
		child.sprite.frame = random
	
