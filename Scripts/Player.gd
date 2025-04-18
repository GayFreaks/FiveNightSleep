extends KinematicBody2D
class_name Player

export(PackedScene) var bullet_scene = null

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
# onready var left_arm = $"Sprite/Skeleton2D/Hip/Chest/Arm L"
# onready var right_arm = $"Sprite/Skeleton2D/Hip/Chest/Arm R"
onready var bullet_cooldown = $ShootCooldown
var flash_shader = null

var rng = RandomNumberGenerator.new()

var weapon_sound = [
	preload ("res://Sound/Effects/PillowWooshLite2.ogg.ogg"),
	preload ("res://Sound/Effects/PillowWooshLite3.ogg"),
	preload ("res://Sound/Effects/PillowWooshLite4.ogg"),
	preload ("res://Sound/Effects/PillowWooshLite5.ogg"),
	preload ("res://Sound/Effects/PillowWooshLite.ogg")
]

var current_weapon = null
var dashing = false

var speed = 500  # speed in pixels/sec
var velocity = Vector2.ZERO
var mouse_pos_rel_player
var mouse_rot_rel_player

func _ready():
	enemy_director.current_player = self
	change_weapon(state.player_weapon)
	health_bar.value = state.player_health
	$CanvasLayer/WinScreen.hide()
	$CanvasLayer.show()
	death_screen.hide()

	flash_shader = $Sprite.get_material()

func get_input():
	var movement_direction = Vector2(Input.get_axis("Move_Left", "Move_Right"), Input.get_axis("Move_Up", "Move_Down"))

	return movement_direction

func change_weapon(new_weapon):
	if typeof(new_weapon) != TYPE_INT:
		print("new_weapon invalid 1")
		return
	
	state.player_weapon = new_weapon

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
		# left_arm.rotation = mouse_rot_rel_player
		# right_arm.rotation = mouse_rot_rel_player

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
					
					rng.randomize()
					var random_index = rng.randi_range(0, 4)
					$AudioStreamPlayer.stream = weapon_sound[random_index]
					$AudioStreamPlayer.play()
			elif event.button_index == 2 && event.pressed:
				if bullet_scene != null && bullet_cooldown.is_stopped():
					var bullet = bullet_scene.instance()
					get_parent().add_child(bullet)
					bullet.global_position = direction_object.global_position
					bullet.global_rotation = direction_object.global_rotation
					
					rng.randomize()
					var random_index = rng.randi_range(0, 4)
					$AudioStreamPlayer.stream = weapon_sound[random_index]
					$AudioStreamPlayer.play()
					
					bullet_cooldown.start()

func _physics_process(_delta):
	velocity = Vector2.ZERO
	if not dashing:
		velocity = get_input().normalized() * speed
	velocity = move_and_slide(velocity)

	if round(velocity.length()) != 0:
		animation.play("JimmyWalk")
	else:
		animation.play("RESET")

	cooldown_display.value = (cooldown.wait_time-cooldown.time_left) * 100

func damage(amount):
	state.player_health -= amount

	if state.player_health <= 0:
		$UICooldown.start()
		death_screen.show()
		enemy_director.clear_enemies()

	flash_shader.set_shader_param("hit_effect", 1.0)
	$FlashTimer.start()

	health_bar.value = state.player_health

func win():
	$UICooldown.start()
	$CanvasLayer/WinScreen.show()

func _on_DeathButton_pressed():
	if $UICooldown.is_stopped():
		state.player_health = 100
		state.player_weapon = 0
		loader.goto_scene_path("res://Main.tscn")

func _on_FlashTimer_timeout():
	flash_shader.set_shader_param("hit_effect", 0.0)
