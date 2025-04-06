extends Area2D
class_name Key

onready var enemy_director = get_node("/root/EnemyDirector")

func _ready():
	enemy_director.current_key = self
	hide()

func spawn(new_pos):
	position = new_pos - Vector2(0,5)
	show()
	monitoring = true

func _on_Key_body_entered(body:Node):
	if body.is_in_group("Player"):
		enemy_director.current_door.change_lock(false)
		hide()
