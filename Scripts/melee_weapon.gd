extends Area2D
class_name MeleeWeaponn

export var damage = 10
export var knockback = 10

onready var sprite = $Sprite
onready var collision = $CollisionShape2D
onready var animation = $AnimationPlayer

func thrust():
	animation.play("Attack")

func _on_body_entered(body:Node):
	if body.is_in_group("Enemy"):
		body.damage(damage, get_parent().position.normalized() * knockback)
