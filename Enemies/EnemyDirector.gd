extends Node
class_name EnemyDirectory

var enemy_index = 0
var current_enemies = []
var current_door = null
var current_player = null

func _ready():
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = 0.5
	timer.connect("timeout", self, "enemy_calc")
	timer.start()

func enemy_died(enemy):
	if enemy in current_enemies:
		current_enemies.erase(enemy)
		if current_enemies.size() < 1:
			if current_door != null:
				current_door.change_lock(false)

func enemy_calc():
	match current_enemies.size():
		1:
			current_enemies[0].state = Cat.states.CHARGE
		2:
			current_enemies[0].state = Cat.states.CHARGE
			current_enemies[1].state = Cat.states.STALK
		3:
			current_enemies[0].state = Cat.states.STALK
			current_enemies[1].state = Cat.states.JUMP
			current_enemies[2].state = Cat.states.STALK
		4:
			current_enemies[0].state = Cat.states.CHARGE
			current_enemies[1].state = Cat.states.STALK
			current_enemies[2].state = Cat.states.JUMP
			current_enemies[3].state = Cat.states.STALK
		5:
			current_enemies[0].state = Cat.states.CHARGE
			current_enemies[1].state = Cat.states.STALK
			current_enemies[2].state = Cat.states.JUMP
			current_enemies[3].state = Cat.states.STALK
			current_enemies[4].state = Cat.states.STALK
		6:
			current_enemies[0].state = Cat.states.JUMP
			current_enemies[1].state = Cat.states.JUMP
			current_enemies[2].state = Cat.states.STALK
			current_enemies[3].state = Cat.states.STALK
			current_enemies[4].state = Cat.states.STALK
			current_enemies[5].state = Cat.states.STALK
		_:
			pass