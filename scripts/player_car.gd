extends CharacterBody2D


var speed = 400.0
const steering_speed = 5.0
var accel = 0.0


func _physics_process(delta: float) -> void:
	# Keep moving forward
	var forward_direction = Vector2.UP.rotated(rotation)
	velocity = forward_direction * speed

	# Get direction (-1 = left, 1 = right)
	var rotate_direction := Input.get_axis("SteeringLeft", "SteeringRight")
	
	# Accelerate so it not instant rotating
	if rotate_direction != 0:
		accel = lerp(accel, rotate_direction, 0.1)
	else:
		accel = lerp(accel, rotate_direction, 0.2)
	# Rotate the car
	rotation += accel * steering_speed * delta


	move_and_slide()
