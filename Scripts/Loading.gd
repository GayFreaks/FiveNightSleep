extends CanvasLayer

var loader
var wait_frames
var time_max = 100 # msec
var current_scene

signal scene_change

func _ready():
	visible = false
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

func goto_scene_path(path): # Game requests to switch to this scene.
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # Check for errors.
		print("No loader?")
		return
	set_process(true)

	current_scene.queue_free() # Get rid of the old scene.

	wait_frames = 1

func goto_scene(path): # Game requests to switch to this scene.
	get_tree().change_scene_to(path)
	set_process(false)

func _process(_time):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return

	var t = OS.get_ticks_msec()
	# Use "time_max" to control for how long we block this thread.
	while OS.get_ticks_msec() < t + time_max:
		# Poll your loader.
		var err = loader.poll()

		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			visible = false
			set_new_scene(resource)
			emit_signal("scene_change")
			break
		elif err == OK:
			update_progress()
		else: # Error during loading.
			print("Error during loading", err)
			loader = null
			break

func update_progress():
	visible = true
	var progress = float(loader.get_stage()) / float(loader.get_stage_count())
	# Update your progress bar?
	$Control/ProgressBar.value = progress

func set_new_scene(scene_resource):
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)
