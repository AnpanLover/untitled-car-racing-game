extends Area2D

const flicker_speed = 1.5
var flicker_pop = 0.0
var time_elapsed: float
const color = {
	"locked": Color(0.81, 0.0, 0.0),
	"next": Color(0.81, 0.446, 0.0),
	"completed": Color(0.0, 0.81, 0.229)
	}

var stage: int

@onready var areadetect: ColorRect = $Areadetect

func _process(delta: float) -> void:
	time_elapsed += delta
	
	stage_checker()

func stage_change(num: int):
	set_meta("stage", num)
	flicker_pop = 0.8

func _on_area_entered(area: Area2D) -> void:
	stage_change(2)
	
func stage_checker():
	stage = get_meta("stage")

	match stage:
		0:
			areadetect.color = color["locked"]
		1:
			areadetect.color = color["next"]
		2:
			areadetect.color = color["completed"]
	
	effect()

func effect():
	# flickering effect
	areadetect.color.a = (sin(time_elapsed * flicker_speed) * 0.15) + 0.25
	
	# the POP! effect idk
	areadetect.color.a += flicker_pop

	if flicker_pop > 0.05:
		flicker_pop = lerp(flicker_pop, 0.0, 0.075)
	else:
		flicker_pop = 0.0
