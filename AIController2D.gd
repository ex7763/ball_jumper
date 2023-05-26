# extends Node
extends AIController2D


# Stores the action sampled for the agent's policy, running in python
# var move_action : float = 0.0
var move_action : int = 0

func get_obs() -> Dictionary:
	# get the balls position and velocity in the paddle's frame of reference
	# var ball_pos = to_local(_player.ball.global_position)
	# var ball_vel = to_local(_player.ball.linear_velocity)
	# var obs = [ball_pos.x, ball_pos.z, ball_vel.x/10.0, ball_vel.z/10.0]
	
	var player = get_node("/root/Scene/player")
	var scene = get_node("/root/Scene")
	var obs = [player.position.x, player.position.y]
	
	for idx in range(scene.num_balls):
		if idx < scene.ball.size():
			obs.append(scene.ball[idx].position.x)
			obs.append(scene.ball[idx].position.y)
		else:
			obs.append(-1.0)
			obs.append(-1.0)

	return {"obs": obs}

func get_reward() -> float:	
	return reward
	
func get_obs_space():
	var scene = get_node("/root/Scene")
	return {
		"obs": {
			"size": [2 + scene.num_balls * 2],
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
	return {
		"move" : {
			"size": 1,
			"action_type": "continuous"
		},
		"jump" : {
			"size": 2,
			"action_type": "discrete"
		},
		}
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
	if action["move"][0] > 0:
		move_action = 0
	else:
		move_action = 1
		
	if action["jump"] == 1:
		move_action = 2
		
	# print(action, move_action)
	# move_action = action["move_action"]
	
	## Continuous
	# move_action = clamp(action["move_action"][0], -1.0, 1.0)
