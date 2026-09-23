extends Area2D

const flicker_speed = 1.5
var time_elapsed: float
const color = {
	"uncheck": Color(0.81, 0.0, 0.0, 0.157),
	"next": Color(0.81, 0.446, 0.0, 0.157),
	"check": Color(0.0, 0.812, 0.231, 0.157)
	}

@onready var color_rect: ColorRect = $ColorRect

func _process(delta: float) -> void:
	time_elapsed += delta
	
	# flickering effect
	color_rect.color.a = (sin(time_elapsed * flicker_speed) * 0.15) + 0.25
	


func _on_area_entered(area: Area2D) -> void:
	color_rect.color = color["check"]
