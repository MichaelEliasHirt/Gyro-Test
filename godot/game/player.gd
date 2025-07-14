extends CharacterBody2D

var speed := 350.0
var gravity := 15.0
var jump_velocity := -800.0

var viewport_size: Vector2
var use_acceleromenter = false
var use_custom_accelerometer = false

var highest_gyro_input = Vector3.ZERO

signal jumped

func _ready() -> void:
	if OS.get_name() == "iOS" or OS.get_name() == "Android":
		use_acceleromenter = true
		check_for_gyro_input()
	elif OS.get_name() == "Web":
		use_custom_accelerometer = true
		check_for_gyro_input()
	
	
	MyUtility.add_log_msg(OS.get_name())
	
	var response = JavaScriptBridge.eval("window.requestGyroscopePermission();")
	MyUtility.add_log_msg(str(response))
	
	viewport_size = get_viewport_rect().size
	speed *= viewport_size.x/600
	$Camera2D.limit_left = 0
	$Camera2D.limit_right = viewport_size.x
	$Camera2D.limit_bottom = viewport_size.y + 122
	$Camera2D.offset.y = -viewport_size.y/8


func _process(_delta: float) -> void:
	if velocity.y >= 0:
		if $AnimationPlayer.current_animation != 'jump':
			$AnimationPlayer.play("jump")
	else:
		if $AnimationPlayer.current_animation != 'fall':
			$AnimationPlayer.play("fall")


func check_for_gyro_input():
	await get_tree().create_timer(5).timeout
	
	if highest_gyro_input == Vector3.ZERO:
		use_custom_accelerometer = false
		use_acceleromenter = false


func _physics_process(_delta: float) -> void:
	velocity.y += gravity
	
	if use_acceleromenter:
		var mobile_input = Input.get_accelerometer()
		if mobile_input != Vector3.ZERO:
			highest_gyro_input = mobile_input
		velocity.x = mobile_input.x * 130
	
	elif use_custom_accelerometer:
		var gyro = $GYROJS.get_gyro()
		velocity.x =gyro.z * -21000
		if gyro != Vector3.ZERO:
			highest_gyro_input = gyro
			
		var direction = Input.get_axis("move_left","move_right")
		if direction: 
			velocity.x += direction * speed
		else:
			velocity.x += move_toward(velocity.x, 0, speed/3)
	else:
		var direction = Input.get_axis("move_left","move_right")
		if direction: 
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed/3)
			
	velocity.y = clampf(velocity.y,-1000,1000)

	var is_collided = move_and_slide()
	
	if is_collided:
		MyUtility.add_log_msg("Debug: " + str(JavaScriptBridge.eval("window.debug;")))
		#MyUtility.add_log_msg(str(velocity.x))
	
		SoundFx.play('Jump')
		jumped.emit()
		velocity.y = jump_velocity
	
	
	var margin = 20
	global_position.x = wrapf(global_position.x,0-margin,viewport_size.x+margin)
	
