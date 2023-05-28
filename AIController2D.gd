# extends Node
extends AIController2D


# Stores the action sampled for the agent's policy, running in python
# var move_action : float = 0.0
var move_action = null

func get_obs() -> Dictionary:
	# get the balls position and velocity in the paddle's frame of reference
	# var ball_pos = to_local(_player.ball.global_position)
	# var ball_vel = to_local(_player.ball.linear_velocity)
	# var obs = [ball_pos.x, ball_pos.z, ball_vel.x/10.0, ball_vel.z/10.0]
#	var viewport_height = ProjectSettings.get_setting("display/window/size/viewport_height")
#	var viewport_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	
	
	var player = get_node("/root/Scene/player")
	var scene = get_node("/root/Scene")
	var obs = [player.position.x / 720.0, player.position.y / 1080.0,
			   player.velocity.x, player.velocity.y]
	
	if player.is_on_floor():
		obs.append(1.0)
	else:
		obs.append(0.0)
#	for idx in range(scene.num_balls):
#		if idx < scene.ball.size():
#			obs.append(scene.ball[idx].position.x)
#			obs.append(scene.ball[idx].position.y)
#		else:
#			obs.append(-1.0)
#			obs.append(-1.0)
			
	var raycast1 = get_node("/root/Scene/player/RaycastSensor2D").get_observation()
	var raycast2 = get_node("/root/Scene/player/RaycastSensor2D2").get_observation()
	var raycast3 = get_node("/root/Scene/player/RaycastSensor2D3").get_observation()
	obs += raycast1 + raycast2 + raycast3

	return {"obs": obs}

func get_reward() -> float:	
#	if move_action == 2:
#		reward -= 0.01
	return reward
	
func get_obs_space():
	var scene = get_node("/root/Scene")
	return {
		"obs": {
			# "size": [4 + scene.num_balls * 2 + 1 + 16],
			"size": [4 + 1 + 16 * 3],
			"space": "box"
		}
	}
	
func get_action_space() -> Dictionary:
#	return {
#		"move_action" : {
#			"size": 3,
#			"action_type": "discrete"
#		}
#		}
	# Hyper
#	return {
#		"move" : {
#			"size": 1,
#			"action_type": "continuous"
#		},
#		"jump" : {
#			"size": 2,
#			"action_type": "discrete"
#		},
#		"idle" : {
#			"size": 2,
#			"action_type": "discrete"
#		},
#		}
	# Continuous
#	return {
#		"move" : {
#			"size": 1,
#			"action_type": "continuous"
#		},
#		"jump" : {
#			"size": 1,
#			"action_type": "continuous"
#		},
#		"idle" : {
#			"size": 1,
#			"action_type": "continuous"
#		},
#		}
	return {
		"move" : {
			"size": 3,
			"action_type": "continuous"
		},
	}

	# Discrete
#	return {
#		"move" : {
#			"size": 2,
#			"action_type": "discrete"
#		},
#		"jump" : {
#			"size": 2,
#			"action_type": "discrete"
#		},
#		"idle" : {
#			"size": 2,
#			"action_type": "discrete"
#		},
#		}
		
#	return {
#		"move_right" : {
#			"size": 2,
#			"action_type": "discrete"
#		},
#		"move_left" : {
#			"size": 2,
#			"action_type": "discrete"
#		},
#		"move_jump" : {
#			"size": 2,
#			"action_type": "discrete"
#		},
#		}
	
func set_action(action) -> void:	
	# Hyper: continuous + discrete
#	if action["move"][0] > 0:
#		move_action = 0
#	else:
#		move_action = 1
#	if action["jump"] == 1:
#		move_action = 2
#	if action["idle"] == 1:
#		move_action = 3
		
	# print(action)
	
	# Continuous only
#	if action["move"][0] > 0:
#		move_action = 0
#	else:
#		move_action = 1
#
#	if action["jump"][0] > 0:
#		move_action = 2
#
#	if action["idle"][0] > 0:
#		move_action = 3

	if action["move"][0] > 0:
		move_action = 0
	else:
		move_action = 1
	if action["move"][1] > 0:
		move_action = 2
	if action["move"][2] > 0:
		move_action = 3
	# print(move_action)

	# Discrete only
#	if action["move"] == 0:
#		move_action = 0
#	else:
#		move_action = 1
#	if action["jump"] == 1:
#		move_action = 2
#	if action["idle"] == 1:
#		move_action = 3
	
	# var player = get_node("/root/Scene/player")
	# player.move_and_slide()
		
		
	# print(action, move_action)
	# move_action = action["move_action"]
	
	## Continuous
	# move_action = clamp(action["move_action"][0], -1.0, 1.0)
