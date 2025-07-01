extends Node2D

@onready var key = $Key
@onready var ball = $Ball
var ball_in_key = false
var current_score = 0
@onready var score_label = %ScoreLabel
@export var capture_effect_scene : PackedScene
const SPEED_INCREASE_RATE = 100
const MAX_BALL_SPEED = 1000
@onready var camera = $Camera
var camera_shake_intensity = 0.0
var camera_shake_duration = 0.0
var camera_offset
@onready var game_over_screen = $GameOverScreen
var ball_initial_position
@export var ball_scene : PackedScene
@export var stars_effect : PackedScene
const LEVEL_UP_RATE = 10
var current_bg_color = 0
@export var bg_colors : Array[Color]
@onready var pause_screen = $PauseScreen
@onready var pause_button = %PauseButton
var failed_processed = false
@onready var failed_screen = $FailedScreen
var game_data = {}


func _ready():
	ball_initial_position = ball.global_position
	Sounds.play_music()
	key.change_position()
	ball.destination = key.global_position


func _process(delta):
	shake_camera(delta)


func _draw():
	draw_rect(Rect2(-200, -200, 1480, 3220), Color(bg_colors[current_bg_color]),
		 true)


func _unhandled_input(event):
	if event is InputEventScreenTouch and event.pressed:
		if ball_in_key:
			key_caught()
		else:
			if !failed_processed:
				failed()
			else:
				game_over()


func key_caught():
	Sounds.play_piano_tone()
	key.play_caught_animation()
	ball.play_capture_animation()
	key.change_position()
	ball.destination = key.global_position
	ball.velocity_calculated = false
	current_score += 1
	score_label.text = str(current_score)
	add_capture_effect(ball.global_position)
	if current_score % LEVEL_UP_RATE == 0:
		level_up()
	camera_shake_duration = 0.4
	camera_shake_intensity = 13.0


func _on_key_ball_entered():
	ball_in_key = true


func _on_key_ball_exited():
	ball_in_key = false


func add_capture_effect(effect_pos):
	var effect = capture_effect_scene.instantiate()
	effect.position = effect_pos
	add_child(effect)
	effect.emitting = true


func failed():
	game_data['key_pos'] = key.global_position
	game_data['current_score'] = current_score
	game_data['ball_speed'] = ball.speed
	pause_button.disabled = true
	Sounds.pause_music()
	Sounds.play_sound(Sounds.SOUNDS.MISSED)
	camera_shake_duration = 0.8
	camera_shake_intensity = 20.0
	ball.destroy()
	set_process_unhandled_input(false)
	add_capture_effect(ball.global_position)
	set_high_score()
	await get_tree().create_timer(1.0).timeout
	failed_screen.animate_in()
	failed_screen.set_current_score(current_score)
	failed_processed = true


func game_over():
	pause_button.disabled = true
	Sounds.stop_music()
	Sounds.play_sound(Sounds.SOUNDS.MISSED)
	camera_shake_duration = 0.8
	camera_shake_intensity = 20.0
	ball.destroy()
	set_process_unhandled_input(false)
	add_capture_effect(ball.global_position)
	set_high_score()
	await get_tree().create_timer(1.0).timeout
	game_over_screen.animate_in()
	game_over_screen.set_current_score(current_score)
	game_over_screen.set_high_score(SavedData.data.high_score)


func set_high_score():
	var high_score = SavedData.data.high_score
	if current_score > high_score:
		SavedData.set_value('high_score', current_score)


func shake_camera(delta):
	camera_offset = Vector2.ZERO
	
	if camera_shake_duration <= 0:
		camera_shake_intensity = 0.0
		camera_shake_duration = 0.0
		return
	
	camera_shake_duration = camera_shake_duration - delta
	camera_offset = Vector2(randf(), randf()) * camera_shake_intensity
	camera.offset = camera_offset


func add_new_ball():
	var new_ball = ball_scene.instantiate()
	new_ball.global_position = ball_initial_position
	ball = new_ball
	add_child(new_ball)


func _reload():
	current_bg_color = 0
	queue_redraw()
	failed_processed = false
	pause_button.disabled = false
	Sounds.play_music()
	Sounds.reset_tones()
	add_new_ball()
	key.change_position()
	ball.destination = key.global_position
	current_score = 0
	score_label.text = str(current_score)
	set_process_unhandled_input(true)


func _on_wall_body_entered(body):
	if !failed_processed:
		failed()
	else:
		game_over()


func level_up():
	if ball.speed < MAX_BALL_SPEED:
		ball.speed += SPEED_INCREASE_RATE
		score_label.pivot_offset = score_label.size/2
		$AnimationPlayer.play("speed_increase")
	
	# add stars effect
	var effect = stars_effect.instantiate()
	add_child(effect)
	effect.emitting = true
	
	Sounds.play_sound(Sounds.SOUNDS.LEVEL_UP)
	
	current_bg_color += 1
	if current_bg_color == bg_colors.size():
		current_bg_color = 0
	
	queue_redraw()


func _on_pause_button_pressed():
	Sounds.play_sound(Sounds.SOUNDS.CLICK)
	Sounds.pause_music()
	get_tree().paused = true
	pause_screen.animate_in()
	pause_screen.set_current_score(current_score)


func _on_failed_screen_ad_watched():
	await get_tree().create_timer(1.0).timeout
	set_process_unhandled_input(true)
	pause_button.disabled = false
	Sounds.resume_music()
	add_new_ball()
	ball.speed = game_data.ball_speed
	key.global_position = game_data.key_pos
	ball.destination = key.global_position
	current_score = game_data.current_score
	score_label.text = str(current_score)
