extends Node

onready var loader = get_node("/root/Loading")
onready var enemy_director = get_node("/root/EnemyDirector")
onready var player = $AudioStreamPlayer
var rng = RandomNumberGenerator.new()

var pillow_lite_noises = [
	preload("res://Sound/Effects/PillowWooshLite2.ogg.ogg"),
	preload("res://Sound/Effects/PillowWooshLite3.ogg"),
	preload("res://Sound/Effects/PillowWooshLite4.ogg"),
	preload("res://Sound/Effects/PillowWooshLite5.ogg"),
	preload("res://Sound/Effects/PillowWooshLite.ogg"),
]

var muzik = [
	preload("res://Sound/Music/TitelTheme.ogg"),
	preload("res://Sound/Music/NonCombat.ogg"),
	preload("res://Sound/Music/Combat1a.ogg"),
	preload("res://Sound/Music/Combat1b.ogg"),
	preload("res://Sound/Music/Combat1c.ogg"),
	preload("res://Sound/Music/Combat2a.ogg"),
	preload("res://Sound/Music/Combat2b.ogg"),
	preload("res://Sound/Music/Combat3.ogg"),
	preload ("res://Sound/Music/Boss theme 2.ogg")
]



# Called when the node enters the scene tree for the first time.
func _ready():
	loader.connect("scene_change", self, "change_music")
	change_music()

func change_music():
	if is_instance_valid(loader.current_scene):
		if loader.current_scene.name == "Main":
			if player.stream != muzik[0]:
				player.stop()
				player.stream = muzik[0]
				player.play()
		elif loader.current_scene.name == "Level9":
			player.stop()
			player.stream = muzik[8]
			player.play()
		elif enemy_director.current_enemies.size() > 3:
			player.stop()
			var random_index = rng.randi_range(2, 4)
			player.stream = muzik[random_index]
			player.play()
		elif enemy_director.current_enemies.size() > 2:
			player.stop()
			var random_index = rng.randi_range(5, 7)
			player.stream = muzik[random_index]
			player.play()
		elif enemy_director.current_enemies.size() == 0:
			player.stop()
			player.stream = muzik[1]
			player.play()
