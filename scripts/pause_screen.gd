extends CanvasLayer

@onready var current_score = %CurrentScore


func _on_resume_button_pressed():
	Sounds.play_sound(Sounds.SOUNDS.CLICK)
	animate_out()
	get_tree().paused = false
	Sounds.resume_music()


func _on_home_button_pressed():
	Sounds.play_sound(Sounds.SOUNDS.CLICK)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func animate_out():
	Sounds.play_sound(Sounds.SOUNDS.SWIPE)
	var tween = create_tween()
	tween.tween_property(self, "offset:y", 1920, 1.0).set_trans\
			(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	offset.y = -1920


func set_current_score(score):
	current_score.text = str(score)


func animate_in():
	var tween = create_tween()
	tween.tween_property(self, "offset:y", 0, 1.0).set_trans\
			(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	await get_tree().create_timer(0.6).timeout
	Sounds.play_sound(Sounds.SOUNDS.SWIPE)
