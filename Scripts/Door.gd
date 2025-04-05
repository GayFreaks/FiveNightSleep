extends Area2D

onready var loader = get_node("/root/Loading")

export var level_name = "LevelX"

func _on_Door_body_entered(body:Node):
	if body.is_in_group("Player"):
		loader.goto_scene_path("res://Levels/" + level_name + ".tscn")
