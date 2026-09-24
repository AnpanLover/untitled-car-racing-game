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
@onready var checkpoint_manager: Node = %CheckpointManager

func _process(delta: float) -> void:
	time_elapsed += delta
	
	# check if it my lap
	var current_lap = checkpoint_manager.current_lap
	if current_lap == get_meta("queue"):
		stage_change(1) # to Next stage
	
	stage_checker()

func stage_change(num: int):
	set_meta("stage", num)

func _on_area_entered(area: Area2D) -> void:
	var current_lap = checkpoint_manager.current_lap
	if current_lap == get_meta("queue"):
		stage_change(2) # to Completed stage
		flicker_pop = 0.8 # POP effect
		checkpoint_manager.passed() # add 1 to current_lap
	
func stage_checker():
	# change color based on metadata "stage"
	stage = get_meta("stage")

	match stage:
		0:
			# locked, cannot pass yet
			areadetect.color = color["locked"]
		1:
			# opened, can pass this
			areadetect.color = color["next"]
		2:
			# completed, already passed this
			areadetect.color = color["completed"]
	
	effect() # some cool effect

func effect():
	# flickering effect
	areadetect.color.a = (sin(time_elapsed * flicker_speed) * 0.15) + 0.25
	
	# the POP! effect when pass checkpoint
	areadetect.color.a += flicker_pop

	if flicker_pop > 0.05:
		flicker_pop = lerp(flicker_pop, 0.0, 0.075)
	else:
		flicker_pop = 0.0
