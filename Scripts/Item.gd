extends Area2D
class_name Item

onready var enemy_director = get_node("/root/EnemyDirector")
onready var collision = $CollisionShape2D
onready var sprite = $Sprite

export var item_index = 0

var items = [
	[preload("res://Assets/Items/Pillow.png"), 0.2, 0.2],
	[preload("res://Assets/Items/HardPillow.png"), 0.2, 0.2],
	[preload("res://Assets/Items/Bed.png"), 0.2, 0.2]
]

func _ready():
	enemy_director.current_enemies.append(self)
	var texture = items[item_index][0]
	sprite.texture = texture
	sprite.scale.x = items[item_index][1]
	sprite.scale.y = items[item_index][2]

func recalc_target():
	pass

func _on_Item_body_entered(body:Node):
	if body.is_in_group("Player"):
		body.change_weapon(item_index)
		enemy_director.enemy_died(self)
		queue_free()
