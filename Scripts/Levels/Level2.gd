extends Node2D

export(NodePath) var door_path

onready var enemy_directory = get_node("/root/EnemyDirector")
onready var door = get_node(door_path)

func _ready():
	enemy_directory.current_door = door
