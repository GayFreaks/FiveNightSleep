extends Control

onready var loader = get_node("/root/Loading")

var main_musik = [ preload ("res://Sound/Music/TitelTheme.ogg") ]
onready var titel_theme = $AudioStreamPlayer

func _ready():
	Engine.set_target_fps(60)
	titel_theme.stream = main_musik[0]
	titel_theme.play()

func _on_PlayButton_pressed():
	loader.goto_scene_path("res://Levels/Level1.tscn")
	titel_theme.stop()
