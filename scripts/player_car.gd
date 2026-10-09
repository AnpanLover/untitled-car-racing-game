extends CharacterBody2D


var speed = 75.0
var max_speed = 2000.0
const steering_speed = 5.0
var accel = 0.0
var is_on_road = false
@onready var current_rotation = rotation

@onready var area_detect: Area2D = $Area2D

func _process(_delta: float) -> void:
	# Detect if on road or not
	var overlapping = area_detect.get_overlapping_areas()
	is_on_road = true if overlapping else false
	
func _physics_process(delta: float) -> void:
	# Keep moving forward
	var forward_direction = Vector2.UP.rotated(current_rotation)
		
	if velocity.length() < max_speed: # cap speed accelerator
		velocity += forward_direction * speed
		
	var friction = 0.975 if is_on_road else 0.94
	velocity *= friction # keep reduce velocity
	
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
		var collider = collision.get_collider()
		var normal = collision.get_normal()
	
		if collider is RigidBody2D:
			var push_force = velocity.length() * (collider.mass * 0.5)
			var hit_position = collision.get_position() - collider.global_position
			collider.apply_impulse(-normal * push_force, hit_position)

			velocity += normal * (collider.mass * 500)
		else:
			velocity = velocity.bounce(normal) * 0.8
			current_rotation -= velocity.angle() * 0.1
	
		# play bumping sound
		var sfx: AudioStreamPlayer2D = $BumpingSound
		sfx.pitch_scale = randf_range(0.75, 1.25)
		if sfx.get_playback_position() < 0.02:
			sfx.playing = true

	
	rotation = lerp_angle(rotation, current_rotation, 0.2)

func lap_passed(lap_count: int):
	set_meta("lap", lap_count)
	
func _on_timer_timeout() -> void:
	var sfx: AudioStreamPlayer2D = $DrivingSound
	sfx.pitch_scale = (velocity.length() / max_speed) * 1.5 + 1.5
	sfx.pitch_scale += randf_range(-0.1, 0.1)
	sfx.playing = true
	var timer: Timer = $DrivingSound/Timer
	timer.wait_time = clamp(0.2 / (velocity.length() / max_speed) * 0.25, 0.001, 0.1)
	timer.start()
