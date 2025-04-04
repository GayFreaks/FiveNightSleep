extends KinematicBody2D
class_name Player

onready var direction_object = $Direction

var speed = 500  # speed in pixels/sec
var velocity = Vector2.ZERO
var mouse_pos_rel_player
var mouse_rot_rel_player

func get_input():
	var movement_direction = Vector2(Input.get_axis("Move_Left", "Move_Right"), Input.get_axis("Move_Up", "Move_Down"))

	return movement_direction

func _unhandled_input(event):
	if event is InputEventMouse:
		var player_on_screen = get_global_transform_with_canvas().get_origin()
		var mouse_on_screen = get_viewport().get_mouse_position()
		mouse_pos_rel_player = mouse_on_screen-player_on_screen
		mouse_pos_rel_player = mouse_pos_rel_player.clamped(100)
		mouse_rot_rel_player = mouse_on_screen.angle_to_point(player_on_screen)
		direction_object.position = mouse_pos_rel_player
		direction_object.rotation = mouse_rot_rel_player

		if event is InputEventMouseButton:
			if event.button_index == 1 && event.pressed:
				print("uwu")

func _physics_process(_delta):
	velocity = Vector2.ZERO
	velocity = get_input().normalized() * speed
	velocity = move_and_slide(velocity)
