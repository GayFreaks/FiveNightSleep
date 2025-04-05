extends RigidBody2D
class_name Cat

export var health = 100
export var speed = 100

onready var enemy_director = get_node("/root/EnemyDirector")
onready var health_bar = $Control/HealthBar

var rng = RandomNumberGenerator.new()

enum states {
	IDLE,
	CHARGE,
	STALK,
	JUMP,
	ATTACK
}

enum goals {
	NONE,
	CHARGE,
	STALK,
	JUMP
}

var state = states.IDLE
var goal = states.IDLE setget goal_change
var target_location = Vector2.ZERO

func goal_change(new_goal):
	if goal == goals.NONE:
		if new_goal == goals.CHARGE:
			target_location = enemy_director.current_player.position
		elif new_goal == goals.STALK:	
			rng.randomize()
			var random_degree = rng.randf_range(0.0, 360.0)
			var random_point = Vector2(cos(deg2rad(random_degree)),sin(deg2rad(random_degree))) * 500
			target_location = enemy_director.current_player.position + random_point



	goal = new_goal

func _ready():
	enemy_director.current_enemies.append(self)

	health_bar.max_value = health
	health_bar.value = health
	health_bar.hide()

func _integrate_forces(_state):
	angular_velocity = 0
	rotation_degrees = 0

func damage(amount, knockback):
	health -= amount
	health_bar.value = health
	health_bar.show()
	if health <= 0:
		enemy_director.enemy_died(self)
		queue_free()

	apply_central_impulse(knockback)

func _physics_process(_delta):
	apply_central_impulse((target_location - position).normalized() * speed)

	if position.distance_to(target_location) < 50:
		if goal == goals.CHARGE:
			goal = goals.NONE
		elif goal == goals.STALK:
			goal = goals.NONE

func _on_AttackDetect_body_entered(body:Node):
	if body.is_in_group("Player"):
		state = states.ATTACK
		if goal == goals.CHARGE:
			goal = goals.NONE
		elif goal == goals.STALK:
			goal = goals.NONE
