extends Control


@onready var high_score = %HighScore
var game = preload("res://scenes/game.tscn")
@export var sounds_on : Texture
@export var sounds_off : Texture
@export var music_on : Texture
@export var music_off : Texture
@onready var sounds_button = %SoundsButton
@onready var music_button = %MusicButton


func _ready():
	high_score.text = str(int(SavedData.data.high_score))
	_set_sounds_settings()
	_set_music_settings()


func _set_sounds_settings():
	if SavedData.data['sounds']:
		sounds_button.texture_normal = sounds_on
	else:
		sounds_button.texture_normal = sounds_off


func _set_music_settings():
	if SavedData.data['music']:
		music_button.texture_normal = music_on
	else:
		music_button.texture_normal = music_off


func _on_sounds_button_pressed():
	Sounds.play_sound(Sounds.SOUNDS.CLICK)
	SavedData.set_value('sounds', !SavedData.data.sounds)
	_set_sounds_settings()


func _on_music_button_pressed():
	Sounds.play_sound(Sounds.SOUNDS.CLICK)
	SavedData.set_value('music', !SavedData.data.music)
	_set_music_settings()


func _on_quit_button_pressed():
	get_tree().quit()


func _on_gui_input(event):
	if event is InputEventScreenTouch and event.pressed:
		Sounds.play_sound(Sounds.SOUNDS.CLICK)
		get_tree().change_scene_to_packed(game)
