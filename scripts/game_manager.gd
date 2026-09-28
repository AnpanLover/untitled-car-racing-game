extends Node

var current_lap = 0
var lap_count: int
var winner_presented = false
var time_passed: float
@onready var goal: Area2D = %Goal
@onready var stop_game: Timer = $StopGame
var timer_end := false

func _process(delta: float) -> void:
	time_passed += delta
	
	var all_checkpoint = get_tree().get_nodes_in_group("checkpoint")
			
	lap_count = all_checkpoint.size()
	
	if Input.is_action_just_pressed("Restart") and winner_presented:
		Engine.time_scale = 1.0
		get_tree().reload_current_scene()
		
	if timer_end == true:
		if Engine.time_scale > 0.05:
			Engine.time_scale = lerp(Engine.time_scale, 0.0, 0.035)
		else:
			Engine.time_scale = 0.0

			
func car_win(car: CharacterBody2D):
	print("Winner: ", car)
	car.add_to_group("winner")
	var ui = $"../CanvasLayer/WinLoseUI"
	var anim = ui.get_node("AnimationPlayer")
	var text = ui.get_node("MarginContainer/VBoxContainer/TimeUsedLabel")
	
	ui.visible = true
	text.text = "Time used: " + time_pretty(time_passed)
	anim.play("FadeIn")
	winner_presented = true
	
	stop_game.start()
			
func lap_passed():
	current_lap += 1

func time_pretty(time_float):
	# return this beauty timer format: "00:00.00"
	var minutes = int(fmod(time_float, 3600) / 60)
	var seconds = int(fmod(time_float, 60))
	var decimals = int(fmod(time_float, 1.0) * 100)
	return "%02d:%02d.%02d" % [minutes, seconds, decimals]


func _on_stop_game_timeout() -> void:
	timer_end = true
	
