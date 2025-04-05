extends Control

onready var loader = get_node("/root/Loading")

func _ready():
	Engine.set_target_fps(60)

func _on_Button_pressed():
	loader.goto_scene("res://Levels/Level1.tscn")
