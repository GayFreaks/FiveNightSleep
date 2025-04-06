extends Area2D
class_name Bullet

export var damage_amount = 20
export(float) var speed_mult = 5.0

func _physics_process(_delta):
	position += Vector2(1, 0).rotated(rotation) * speed_mult

func _on_Bullet_body_entered(body:Node):
	if body.is_in_group("Enemy"):
		body.damage(damage_amount, Vector2.ZERO)
		queue_free()

func _on_DeletionTimeout_timeout():
	queue_free()
