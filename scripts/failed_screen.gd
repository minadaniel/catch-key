extends CanvasLayer


@onready var current_score = %CurrentScore
signal reload
signal ad_watched
var rewarded = false
@onready var watch_ad_container = %WatchAdContainer
@onready var loading_label = %LoadingLabel


func _ready():
	show_loading_ad(false)


func _on_watch_ad_button_pressed():
	Sounds.play_sound(Sounds.SOUNDS.CLICK)
	$AdMob.load_rewarded_video()
	show_loading_ad(true)
#	animate_out()
#	ad_watched.emit()


func show_loading_ad(value):
	watch_ad_container.visible = !value
	loading_label.visible = value


func _on_reload_button_pressed():
	Sounds.play_sound(Sounds.SOUNDS.CLICK)
	await animate_out()
	show_loading_ad(false)
	reload.emit()
	

func _on_home_button_pressed():
	Sounds.play_sound(Sounds.SOUNDS.CLICK)
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


func _on_ad_mob_rewarded(currency, amount):
	print('_on_ad_mob_rewarded ', currency, amount)
	rewarded = true


func _on_ad_mob_rewarded_clicked():
	print("_on_ad_mob_rewarded_clicked")


func _on_ad_mob_rewarded_impression():
	print("_on_ad_mob_rewarded_impression")


func _on_ad_mob_rewarded_video_closed():
	print("_on_ad_mob_rewarded_video_closed")
	if rewarded:
		animate_out()
		ad_watched.emit()


func _on_ad_mob_rewarded_video_failed_to_load(error_code):
	print("_on_ad_mob_rewarded_video_failed_to_load ", error_code)


func _on_ad_mob_rewarded_video_loaded():
	$AdMob.show_rewarded_video()


func _on_ad_mob_rewarded_video_opened():
	print("_on_ad_mob_rewarded_video_opened")
