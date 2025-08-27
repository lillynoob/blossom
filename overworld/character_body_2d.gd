extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var ACCEL = 15.0
var FRICTION = 14.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if $AnimationPlayer.current_animation != "fall" and $AnimationPlayer.current_animation != "jump":
			$AnimationPlayer.play("fall")
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimationPlayer.play('jump')

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if !Input.is_action_just_pressed("ui_accept") and is_on_floor() and $AnimationPlayer.current_animation != 'walk':
			$AnimationPlayer.play('walk')
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL+FRICTION)
		$AnimationPlayer.speed_scale = move_toward($AnimationPlayer.speed_scale, 2.0, 0.01)
		if direction < 0:
			$PoppyNewestRigCutout.flip_h = true
		else:
			$PoppyNewestRigCutout.flip_h = false
	else:
		if is_on_floor() and $AnimationPlayer.current_animation != 'idle' and $AnimationPlayer.current_animation != 'jump':
			$AnimationPlayer.play('idle')
		velocity.x = move_toward(velocity.x, 0, FRICTION)
		$AnimationPlayer.speed_scale = 1
	
	move_and_slide()

func _callFallAnim():
	$AnimationPlayer.play("fall")
