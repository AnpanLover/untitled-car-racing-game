extends Marker2D

var every_obstacle = [
	preload("uid://cwfsxh15hkkt6"),
	preload("uid://d3308x7slojqv"),
	preload("uid://b0voarbyxoh3t"),
	preload("uid://0sylo2b1ixkw")
]

func _ready() -> void:
	position += Vector2(randi_range(-100, 100), randi_range(-100, 100))
	await get_tree().create_timer(0.1).timeout
	var i = randi_range(0, every_obstacle.size() - 1)
	var obstacle = every_obstacle[i].instantiate()
	obstacle.position = global_position
	get_tree().current_scene.add_child(obstacle)
