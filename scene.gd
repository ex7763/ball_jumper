extends Node2D

var ball_speed = 130
var num_balls = 10
const Ball = preload('res://ball_0.tscn')

var status = "alive"
var ball = []

func _ready():
	print($player.position)
	$player/AnimationPlayer.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if status == "alive":
		if len(ball) == 0:
			ball.append(Ball.instantiate())
			ball[-1].position.x = $player.position.x
			ball[-1].position.y = $player.position.y + 100
			get_parent().add_child(ball[-1])

		while len(ball) < num_balls:
			ball.append(Ball.instantiate())
			ball[-1].position.x = randi() % ProjectSettings.get_setting("display/window/size/viewport_width")
			ball[-1].position.y = randi() % ProjectSettings.get_setting("display/window/size/viewport_height")
			get_parent().add_child(ball[-1])

		var remove_count = 0
		for idx in ball.size():
			var b = ball[idx - remove_count]
			if b.position.y > ProjectSettings.get_setting("display/window/size/viewport_height"):
				# $ball0.queue_free()
				b.queue_free()
				ball.remove_at(idx - remove_count)
				remove_count += 1
			else:
				b.position.y += delta * ball_speed

		check_died()
	else:
		print("died..")
		reset()

func reset():
	$player.position.x = ProjectSettings.get_setting("display/window/size/viewport_width") / 2
	$player.position.y = ProjectSettings.get_setting("display/window/size/viewport_height") / 2
	$player.velocity = Vector2(0.0, 0.0)

func check_died():
	if $player.position.y > ProjectSettings.get_setting("display/window/size/viewport_height"):
		print("died")
		status = "died"
		get_tree().get_root().add_child(preload("res://game_over.tscn").instantiate())


#		queue_free()
#		for idx in ball.size():
#			ball[idx].queue_free()
		# get_tree().get_node("").free()
	# if get_tree().get_root().get_child():

	# var root = get_tree().get_root()
	# for i in range(root.get_child_count()):
	# 	var child = root.get_child(i)
