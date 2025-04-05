extends Node
class_name EnemyDirectory

var current_enemies = []

var current_door = null

func enemy_died(enemy):
	if enemy in current_enemies:
		current_enemies.erase(enemy)
		if current_enemies.size() < 1:
			if current_door != null:
				current_door.change_lock(false)