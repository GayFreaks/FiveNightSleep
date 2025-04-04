extends Area2D

onready var enemy_director = get_node("/root/EnemyDirector")
onready var loader = get_node("/root/Loading")
onready var lock_sprite = $Lock
onready var lock_collision = $StaticBody2D/CollisionShape2D

export var locked = true
export var level_name = "LevelX"

export(Texture) var lock_icon
export(Texture) var unlock_icon

func _ready():
	enemy_director.current_door = self
	change_lock(locked)

func change_lock(new_status):
	locked = new_status
	if locked:
		if lock_icon != null:
			lock_sprite.texture = lock_icon
		lock_collision.set_deferred("disabled", false)
	else:
		if unlock_icon != null:
			lock_sprite.texture = unlock_icon
		lock_collision.set_deferred("disabled", true)

func _on_Door_body_entered(body:Node):
	if body.is_in_group("Player"):
		print("res://Levels/" + level_name + ".tscn")
		enemy_director.current_door = null
		loader.goto_scene_path("res://Levels/" + level_name + ".tscn")
