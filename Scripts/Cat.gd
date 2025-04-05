extends RigidBody2D
class_name Cat

export var health = 100

onready var enemy_directory = get_node("/root/EnemyDirector")
onready var health_bar = $Control/HealthBar

enum states {
	IDLE,
	PURSUE,
	ATTACK,
	FLEE
}

var state = states.IDLE

func _ready():
	enemy_directory.current_enemies.append(self)

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
		enemy_directory.enemy_died(self)
		queue_free()

	apply_central_impulse(knockback)

func _on_Detection_body_entered(body:Node):
	if body.is_in_group("Player"):
		state = states.PURSUE
