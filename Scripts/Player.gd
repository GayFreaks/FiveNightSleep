extends KinematicBody2D

var speed = 500  # speed in pixels/sec
var velocity = Vector2.ZERO

func get_input():
	var direction = Vector2(Input.get_axis("Move_Left", "Move_Right"), Input.get_axis("Move_Up", "Move_Down"))

	return direction

func _physics_process(_delta):
	velocity = Vector2.ZERO
	velocity = get_input().normalized() * speed
	velocity = move_and_slide(velocity)