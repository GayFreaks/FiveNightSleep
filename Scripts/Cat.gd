extends RigidBody2D
class_name Cat

export var health = 100

onready var health_bar = $Control/HealthBar

func _ready():
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
        queue_free()

    apply_central_impulse(knockback)