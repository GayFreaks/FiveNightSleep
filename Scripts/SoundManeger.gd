extends Node

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
]

var cat_noises = [
	preload("res://Sound/Effects/CatAmbience2.ogg"),
	preload("res://Sound/Effects/CatAmbience3.ogg"),
	preload("res://Sound/Effects/CatAmbience4.ogg"),
	preload("res://Sound/Effects/CatAmbience.ogg"),
	preload("res://Sound/Effects/CatHiss2.ogg"),
	preload("res://Sound/Effects/CatHiss.ogg"),
	preload("res://Sound/Effects/CatYell2.ogg"),
	preload("res://Sound/Effects/CatYell.ogg"),
]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(delta):
	rng.randomize()
	var variable = rng.randi_range(0, 5)	
	
	
	
	pass # Replace with function body.
