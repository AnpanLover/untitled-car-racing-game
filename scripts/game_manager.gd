extends Node

var current_lap = 0
var lap_count: int
var winner_presented = false
var time_passed: float
@onready var goal: Area2D = %Goal

func _process(delta: float) -> void:
	time_passed += delta
	
	var all_checkpoint = get_tree().get_nodes_in_group("checkpoint")
			
	lap_count = all_checkpoint.size()
	
	if Input.is_action_just_pressed("Restart") and winner_presented:
		get_tree().reload_current_scene()
			
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
			
func lap_passed():
	current_lap += 1

func time_pretty(time_float):
	# return this beauty timer format: "00:00.00"
	var minutes = int(fmod(time_float, 3600) / 60)
	var seconds = int(fmod(time_float, 60))
	var decimals = int(fmod(time_float, 1.0) * 100)
	return "%02d:%02d.%02d" % [minutes, seconds, decimals]
