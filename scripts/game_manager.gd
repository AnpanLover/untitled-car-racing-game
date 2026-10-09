extends Node

var current_lap = 0
var lap_count: int
var winner_presented = false
var time_passed: float
@onready var goal: Area2D = %Goal
@onready var stop_game: Timer = $StopGame
var timer_end := false
var game_state = 0

func _ready() -> void:
	# connect signal with play button
	var menu: Control = $CanvasLayer/Menu
	var button = menu.get_node("CenterContainer/MarginContainer/PlayButton")
	button.button_down.connect(_on_button_down)

func _process(delta: float) -> void:
	if game_state == 2: time_passed += delta
	
	var all_checkpoint = get_tree().get_nodes_in_group("checkpoint")
			
	lap_count = all_checkpoint.size()
	
	update_ui()
	
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
	var ui = $CanvasLayer/WinLoseUI
	var confetti = $CanvasLayer/Confetti
	var anim = ui.get_node("AnimationPlayer")
	var text = ui.get_node("MarginContainer/VBoxContainer/TimeUsedLabel")
	var animation_player: AnimationPlayer = $CanvasLayer/Stats/AnimationPlayer

	animation_player.play("leaving")
	confetti.emitting = true
	ui.visible = true
	text.text = "Time used: " + time_pretty(time_passed)
	anim.play("FadeIn")
	winner_presented = true
	
	stop_game.start()
			
func lap_passed():
	current_lap += 1
	var animation_player: AnimationPlayer = $CanvasLayer/Stats/AnimationPlayer
	if current_lap != lap_count:
		animation_player.play("wink")
	else:
		animation_player.play("wink_2")

func time_pretty(time_float):
	# return this beauty timer format: "00:00.00"
	var minutes = int(fmod(time_float, 3600) / 60)
	var seconds = int(fmod(time_float, 60))
	var decimals = int(fmod(time_float, 1.0) * 100)
	return "%02d:%02d.%02d" % [minutes, seconds, decimals]


func _on_stop_game_timeout() -> void:
	timer_end = true
	
func update_ui():
	var ui = $CanvasLayer/Stats/MarginContainer/VBoxContainer
	var timer: Label = ui.get_node("Timer")
	timer.text = time_pretty(time_passed)
	
	var score: Label = ui.get_node("Score")
	score.text = str(current_lap, "/", lap_count)


func _on_button_down():
	if game_state == 0:
		game_state = 1
		var menu: Control = $CanvasLayer/Menu
		menu.get_node("AnimationPlayer").play("fadeout")
		menu.get_node("Click").playing = true
		await get_tree().create_timer(1.5).timeout
		
		var countdown_anim: AnimationPlayer = $CanvasLayer/Countdown/AnimationPlayer
		countdown_anim.play("start")
		await get_tree().create_timer(3).timeout
		game_state = 2

		await get_tree().create_timer(1).timeout
		var stat_anim: AnimationPlayer = $CanvasLayer/Stats/AnimationPlayer
		stat_anim.play("entering")
