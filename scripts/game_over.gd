extends CanvasLayer


@onready var current_score = %CurrentScore
@onready var high_score = %HighScore
signal reload


func animate_in():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "offset:y", 0, 1.0).set_trans\
			(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	await get_tree().create_timer(0.6).timeout
	Sounds.play_sound(Sounds.SOUNDS.SWIPE)


func _on_reload_button_pressed():
	Sounds.play_sound(Sounds.SOUNDS.CLICK)
	await animate_out()
	reload.emit()


func _on_home_button_pressed():
	Sounds.play_sound(Sounds.SOUNDS.CLICK)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func set_current_score(score):
	current_score.text = str(score)


func set_high_score(score):
	high_score.text = "HIGH SCORE: " + str(score)


func animate_out():
	Sounds.play_sound(Sounds.SOUNDS.SWIPE)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "offset:y", 1920, 1.0).set_trans\
			(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	offset.y = -1920
