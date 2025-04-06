extends Node
class_name EnemyDirectory

var enemy_index = 0
var current_enemies = []
var current_door = null setget door_set
var current_key = null
var current_player = null

func door_set(new_door):
	if current_key != null && is_instance_valid(current_key) && new_door != null && is_instance_valid(new_door):
		current_key.current_door = new_door

	current_door = new_door

func _ready():
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = 1
	timer.connect("timeout", self, "enemy_calc")
	timer.start()

func enemy_died(enemy):
	if enemy in current_enemies:
		current_enemies.erase(enemy)
		if current_enemies.size() < 1:
			if current_key != null && is_instance_valid(current_key):
				current_key.spawn(enemy.position)

func clear_enemies():
	for i in current_enemies:
		if i != null && is_instance_valid(i):
			enemy_died(i)
			i.queue_free()

func enemy_calc():
	for i in current_enemies:
		if i != null && is_instance_valid(i):
			i.recalc_target()
		else:
			current_enemies.erase(i)
