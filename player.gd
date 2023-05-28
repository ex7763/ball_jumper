extends CharacterBody2D

@onready var ai_controller  = get_node("/root/Scene/AIController2D")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var ai_action = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		# position.y += 300 * delta
	else:
		velocity.y = gravity
		# velocity.y = 0
		# position.y += 0 * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or is_on_wall() or is_on_ceiling()):
		velocity.y = JUMP_VELOCITY
#	if Input.is_action_just_pressed("ui_accept"):
#		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if not ai_action:
		if direction:
			# velocity.x = direction * SPEED
			position.x += direction * 3
		else:
			pass
			# velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# print("godot", ai_controller.move_action)
	if not ai_controller.move_action  == null:
		if ai_controller.move_action == 0:
			# print("right")
			move_right()
		elif ai_controller.move_action == 1:
			#print("left")
			move_left()
		elif ai_controller.move_action == 2:
			# print("jump")
			move_jump()
		elif ai_controller.move_action == 3:
			# print("jump")
			move_idle()
		
	if direction:
		$Sprite2D.flip_h = false if direction > 0 else true
	else:
		pass
#		if velocity.x > 0:
#			$Sprite2D.flip_h = false
#		else:
#			$Sprite2D.flip_h = true
		
	# print("1")
	velocity.x = 0
	move_and_slide()
	# ai_action = false
	# print($RaycastSensor2D.get_observation())

func move_right():
	#velocity.x = SPEED
	position.x += 3
	$Sprite2D.flip_h = false
	#move_and_slide()
	ai_action = true
	
func move_left():
	#velocity.x = -SPEED
	position.x += -3
	$Sprite2D.flip_h = true
	#move_and_slide()
	ai_action = true
	
func move_jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
	#move_and_slide()
	ai_action = true

func move_idle():
	# velocity.x = 0.0
	#move_and_slide()
	ai_action = true
