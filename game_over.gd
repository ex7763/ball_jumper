extends CanvasLayer

var game_scene = preload("res://scene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_again_button_pressed():
	print("try again")
	# get_tree().get_root().add_child(game_scene.instantiate())

	# get_tree().get_root().remove_child(self)
	queue_free()
	get_node("/root/Scene").status = "alive"

	# var node = get_node("/root/Scene")
	# print(node)

func _on_quit_button_pressed():
	get_tree().quit()
