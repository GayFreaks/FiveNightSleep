extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
func _process(delta):
	
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
	
	pass # Replace with function body.
