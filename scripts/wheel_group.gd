extends Node2D


func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	var random = RandomNumberGenerator.new().randi_range(0, 3)
	var childs = get_children()
	
	for child in childs:
		child.sprite.frame = random
	
