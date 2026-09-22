extends CharacterBody2D


var speed = 50.0
var max_speed = 2000.0
const steering_speed = 5.0
var accel = 0.0
const bounce_multiplier = 0.9
var current_rotation = 0.0

@onready var road_detect: Area2D = $RoadDetect

func _process(delta: float) -> void:
	var overlapping = road_detect.get_overlapping_areas()
	
	for area in overlapping:
		print(area.get_node("ColorRect"))
		var rect = area.get_node("ColorRect")
		var color = [Color.AQUA, Color.DARK_CYAN, Color.PALE_TURQUOISE]
		rect.color = color.pick_random()

func _physics_process(delta: float) -> void:
	# Keep moving forward
	var forward_direction = Vector2.UP.rotated(current_rotation)
	if velocity.length() < max_speed:
		velocity += forward_direction * speed
	velocity *= 0.98
	
	# Get direction (-1 = left, 1 = right)
	var rotate_direction := Input.get_axis("SteeringLeft", "SteeringRight")
	
	# Accelerate so it not instant rotating
	if rotate_direction != 0:
		accel = lerp(accel, rotate_direction, 0.1)
	else:
		accel = lerp(accel, rotate_direction, 0.2)
	# Rotate the car
	current_rotation += accel * steering_speed * delta

	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal()) * bounce_multiplier
		current_rotation += velocity.angle() * 0.5
	
	rotation = lerp_angle(rotation, current_rotation, 0.2)
