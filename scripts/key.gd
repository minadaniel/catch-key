extends Area2D

signal ball_entered
signal ball_exited
@export var spawn_rect : Rect2
const ITERATIONS = 500
const MINIMUM_DISTANCE = 200


func _on_body_entered(body):
	if body is Ball:
		emit_signal("ball_entered")


func _on_body_exited(body):
	if body is Ball:
		ball_exited.emit()


func change_position():
	var new_position = Vector2.ZERO
	
	for _i in range(ITERATIONS):
		new_position.x = randi_range(spawn_rect.position.x, spawn_rect.end.x)
		new_position.y = randi_range(spawn_rect.position.y, spawn_rect.end.y)
		
		# check if new position is close to current ball position
		if global_position.distance_to(new_position) > MINIMUM_DISTANCE:
			global_position = new_position
			break


func play_caught_animation():
	$AnimationPlayer2.play('caught')
