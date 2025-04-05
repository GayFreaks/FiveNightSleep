extends Control

onready var loader = get_node("/root/Loading")

func _ready():
	Engine.set_target_fps(60)

func _on_PlayButton_pressed():
	loader.goto_scene_path("res://Levels/Level1.tscn")
