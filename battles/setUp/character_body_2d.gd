extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -400.0
const ACCEL = 20.0
var FRICTION = 10.0
var input : Vector2

var mouse_mode = false
var YOU_EXIST = false

func _physics_process(delta: float) -> void:
	if YOU_EXIST:
		if Input.is_action_just_pressed("ui_accept"):
			click()
		
		var playerInput = _get_input()
		
		if playerInput:
			mouse_mode = false
		
		var lerp_weight = delta * (ACCEL if playerInput else FRICTION)
		
		velocity = lerp(velocity, playerInput * SPEED, lerp_weight)
		
		if mouse_mode:
			position = get_global_mouse_position()
		
		move_and_slide()

func click():
	call_deferred("do_a_left_click")

func do_a_left_click():
	var a = InputEventMouseButton.new()
	a.set_button_index(1)
	a.set_pressed(true)
	a.position = position
	Input.parse_input_event(a)


func _on_control_mouse_entered() -> void:
	mouse_mode = true

func _get_input():
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return input.normalized()
