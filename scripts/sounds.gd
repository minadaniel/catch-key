extends Node


enum SOUNDS {CLICK, MISSED, SWIPE, LEVEL_UP}
@onready var piano_tones = $Piano.get_children()
var current_tone = 0
@onready var music = $Music


func play_sound(sound):
	if not SavedData.data['sounds']:
		return
		
	match sound:
		SOUNDS.CLICK:
			$Click.play()
		SOUNDS.MISSED:
			$Missed.play()
		SOUNDS.SWIPE:
			$Swipe.play()
		SOUNDS.LEVEL_UP:
			$LevelUp.play()


func play_piano_tone():
	if not SavedData.data['sounds']:
		return
	
	piano_tones[current_tone].play()
	
	if current_tone == piano_tones.size() - 1:
		current_tone = 0
		return
		
	current_tone += 1


func reset_tones():
	current_tone = 0


func play_music():
	if not SavedData.data['music']:
		return
	$Music.play()

func stop_music():
	if music.playing:
		music.stop()

func pause_music():
	if not SavedData.data['music']:
		return
		
	music.stream_paused = true


func resume_music():
	if not SavedData.data['music']:
		return
		
	music.stream_paused = false
