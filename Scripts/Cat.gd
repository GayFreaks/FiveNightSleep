extends RigidBody2D
class_name Cat

export var health = 100

onready var enemy_director = get_node("/root/EnemyDirector")
onready var health_bar = $Control/HealthBar

enum states {
	IDLE,
	CHARGE,
	STALK,
	JUMP
}

var state = states.IDLE setget state_change
var goal = states.IDLE
var target_location = Vector2.ZERO

func state_change(new_state):
	if goal == states.IDLE:
		if new_state == states.CHARGE:
			target_location = enemy_director.current_player.position - self.position
	
	state = new_state

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
	apply_central_impulse(target_location.normalized() * 10)

	# if goal == states.CHARGE:
	# 	if navigation.is_navigation_finished():
	# 		goal = states.IDLE
