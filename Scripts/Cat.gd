extends RigidBody2D
class_name Cat

export var health = 100
export var speed = 100
export var given_damage = 20

var cat_noises = [
	preload("res://Sound/Effects/CatAmbience2.ogg"),
	preload("res://Sound/Effects/CatAmbience3.ogg"),
	preload("res://Sound/Effects/CatAmbience4.ogg"),
	preload("res://Sound/Effects/CatAmbience.ogg"),
	preload("res://Sound/Effects/CatHiss2.ogg"),
	preload("res://Sound/Effects/CatHiss.ogg"),
	preload("res://Sound/Effects/CatYell2.ogg"),
	preload("res://Sound/Effects/CatYell.ogg"),
]

onready var sound_manager = get_node("/root/SoundManeger")
onready var enemy_director = get_node("/root/EnemyDirector")
onready var health_bar = $Control/HealthBar
onready var animation = $Cat/AnimationPlayer

var rng = RandomNumberGenerator.new()

var target_location = Vector2.ZERO

func recalc_target():
	rng.randomize()
	var random_degree = rng.randf_range(0.0, 360.0)
	var random_point = Vector2(cos(deg2rad(random_degree)),sin(deg2rad(random_degree))) * 400
	target_location = enemy_director.current_player.position + random_point

func _ready():
	enemy_director.current_enemies.append(self)

	health_bar.max_value = health
	health_bar.value = health
	health_bar.hide()

	animation.connect("animation_finished", self, "anim_done")

func _integrate_forces(_state):
	angular_velocity = 0
	rotation_degrees = 0

func damage(amount, knockback):
	health -= amount
	health_bar.value = health
	health_bar.show()

	animation.play("CastPushed")

	rng.randomize()
	if $AudioStreamPlayer2d.playing == false:
		var random_index = rng.randi_range(0, 7)
		$AudioStreamPlayer.play(sound_manager.cat_noises[random_index])
	if health <= 0:
		enemy_director.enemy_died(self)
		queue_free()

	apply_central_impulse(knockback)

func _physics_process(_delta):
	apply_central_impulse((target_location - position).normalized() * speed)

	if animation.current_animation != "CastPushed":
		animation.play("CatWalk")
	
		if round(linear_velocity.x) > 0:
			$Cat.scale.x = -1.5
			$CollisionShape2D.scale.x = -1
		elif round(linear_velocity.x) < 0:
			$Cat.scale.x = 1.5
			$CollisionShape2D.scale.x = 1

func anim_done(anim_name):
	if anim_name == "CastPushed":
		animation.current_animation = ""

func _on_AttackDetect_body_entered(body:Node):
	if body.is_in_group("Player"):
		sound_manager.player.play()
		animation.play("CastPushed")
		body.damage(given_damage)
