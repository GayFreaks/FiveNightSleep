extends KinematicBody2D
class_name Player

onready var loader = get_node("/root/Loading")
onready var state = get_node("/root/GameState")
onready var enemy_director = get_node("/root/EnemyDirector")
onready var direction_object = $Direction
onready var pillow = $Direction/Pillow
onready var hard_pillow = $Direction/HardPillow
onready var bed = $Direction/Bed
onready var health_bar = $CanvasLayer/UI/HealthBar
onready var cooldown_display = $CanvasLayer/UI/Cooldown
onready var cooldown = $ShootCooldown
onready var death_screen = $CanvasLayer/DeathScreen
onready var animation = $Sprite/AnimationPlayer

var weapon_index = 0
var current_weapon = null
var dashing = false

var speed = 500  # speed in pixels/sec
var velocity = Vector2.ZERO
var mouse_pos_rel_player
var mouse_rot_rel_player

func _ready():
	enemy_director.current_player = self
	change_weapon(weapon_index)
	health_bar.value = state.player_health
	death_screen.hide()

func get_input():
	var movement_direction = Vector2(Input.get_axis("Move_Left", "Move_Right"), Input.get_axis("Move_Up", "Move_Down"))

	return movement_direction

func change_weapon(new_weapon):
	if typeof(new_weapon) != TYPE_INT:
		print("new_weapon invalid 1")
		return

	weapon_index = new_weapon

	if current_weapon != null:
		current_weapon.hide()

	match new_weapon:
		0:
			current_weapon = pillow
		1:
			current_weapon = hard_pillow
		2:
			current_weapon = bed
		_:
			print("new_weapon invalid 2")
			return

	current_weapon.show()

func _unhandled_input(event):
	if event is InputEventMouse:
		var player_on_screen = get_global_transform_with_canvas().get_origin()
		var mouse_on_screen = get_viewport().get_mouse_position()
		mouse_pos_rel_player = mouse_on_screen-player_on_screen
		mouse_pos_rel_player = mouse_pos_rel_player.normalized() * 60
		mouse_rot_rel_player = mouse_on_screen.angle_to_point(player_on_screen)
		direction_object.position = mouse_pos_rel_player
		direction_object.rotation = mouse_rot_rel_player

		if mouse_pos_rel_player.x < 0:
			if current_weapon != null:
				current_weapon.scale.y = -1
		else:
			if current_weapon != null:
				current_weapon.scale.y = 1

		if event is InputEventMouseButton:
			if event.button_index == 1 && event.pressed:
				if current_weapon != null:
					current_weapon.thrust()
	
	if event.is_action_pressed("Dash") && not dashing:
		dashing = true
		

func _physics_process(_delta):
	velocity = Vector2.ZERO
	if not dashing:
		velocity = get_input().normalized() * speed
	velocity = move_and_slide(velocity)

	if not dashing:
		if round(velocity.length()) != 0:
			animation.play("JimmyWalk")
	else:
		animation.play("JimmyDash")

	cooldown_display.value = cooldown.time_left/cooldown.wait_time

func damage(amount):
	state.player_health -= amount

	if state.player_health <= 0:
		death_screen.show()

	health_bar.value = state.player_health

func _on_DeathButton_pressed():
	state.player_health = 100
	loader.goto_scene_path("res://Main.tscn")
