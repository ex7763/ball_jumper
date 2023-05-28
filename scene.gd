extends Node2D

@onready var ai_controller  = $AIController2D

var ball_speed = 130
var num_balls = 10
const Ball = preload('res://ball_0.tscn')

var status = "alive"
var ball = []
var game_over_scene
var score = 0

func _ready():
	print($player.position)
	$player/AnimationPlayer.play("idle")
	ai_controller.init(self)
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var viewport_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	var viewport_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	
	if not ai_controller.move_action  == null \
		and ai_controller.needs_reset:
		# print("ai needs_reset")
		get_node("/root/Scene").status = "alive"
		if game_over_scene:
			game_over_scene.queue_free()
		ai_controller.reset()
		reset()
		return
		
	# if ai_controller.heuristic == "human":
	# print("get rl action: ", ai_controller.move_action)

	if status == "alive":
		if len(ball) == 0:
			ball.append(Ball.instantiate())
			ball[-1].position.x = $player.position.x
			ball[-1].position.y = $player.position.y + 150
			get_parent().add_child(ball[-1])

		while len(ball) < num_balls:
			ball.append(Ball.instantiate())
			ball[-1].position.x = ball[-2].position.x + \
					(((randf()-0.5) * 0.6) * viewport_width)
			ball[-1].position.x = min(max(ball[-1].position.x, 0), viewport_width)
			if ball[-1].position.x == viewport_width:
				ball[-1].position.x = ball[-2].position.x + \
						(((-0.5 * randf()) * 0.6) * viewport_width)
			if ball[-1].position.x == 0:
				ball[-1].position.x = ball[-2].position.x + \
						(((+0.5 * randf()) * 0.6) * viewport_width)
			ball[-1].position.y = ball[-2].position.y - randf() * 50 - 100
			# ball[-1].position.y = randi() % ProjectSettings.get_setting("display/window/size/viewport_height")
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
		if status == "alive":
			ai_controller.reward = 1 * delta
		elif status == "died":
			ai_controller.reward = -1
		score += ai_controller.reward
	else:
		reset()

func reset():
	$player.position.x = ProjectSettings.get_setting("display/window/size/viewport_width") / 2
	$player.position.y = ProjectSettings.get_setting("display/window/size/viewport_height") / 2
	$player.velocity = Vector2(0.0, 0.0)
	
	score = 0
	
#	ball = []
#	for i in num_balls:
#		ball.append(Ball.instantiate())
#		ball[-1].position.x = randi() % ProjectSettings.get_setting("display/window/size/viewport_width")
#		ball[-1].position.y = i / num_balls * ProjectSettings.get_setting("display/window/size/viewport_width")
#		# ball[-1].position.y = randi() % ProjectSettings.get_setting("display/window/size/viewport_height")
#		get_parent().add_child(ball[-1])

func check_died():
	if $player.position.y > ProjectSettings.get_setting("display/window/size/viewport_height"):
		# print("died")
		print("died, score: ", score)
		status = "died"
		game_over()
		
		
		# get_tree().get_node("").free()
	# if get_tree().get_root().get_child():

	# var root = get_tree().get_root()
	# for i in range(root.get_child_count()):
	# 	var child = root.get_child(i)

func game_over():
	ai_controller.done = true
	ai_controller.needs_reset = true

	game_over_scene = preload("res://game_over.tscn").instantiate()
	get_tree().get_root().add_child(game_over_scene)
#		queue_free()
	for idx in ball.size():
		ball[idx].queue_free()
	ball = []
