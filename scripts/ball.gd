extends CharacterBody2D
class_name Ball


var speed = 300
var destination
@onready var trail = $Trail
var velocity_calculated = false
signal ball_exited_screen


func _physics_process(delta):
	if destination and !velocity_calculated:
		look_at(destination)
		velocity = (destination - global_position).normalized() * speed
		velocity_calculated = true
		
	move_and_slide()


func destroy():
	velocity = Vector2.ZERO
	trail.emitting = false
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2(0.3, 0.3), 0.3)
	await tween.finished
	queue_free()


func play_capture_animation():
	$AnimationPlayer.play("capture")
