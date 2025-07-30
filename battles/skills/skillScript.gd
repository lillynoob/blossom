extends Node2D

@export var skill_name = "Basic_ATK"
@export var direction = Vector2(0,0)
@export var SPEED = 200.0
@export var ACCEL = 50.0
@export var readyUp = true
@export var icon : Texture
@export var timerTimeout = 4
@export var is_position_based_on_char = false
@export var passthrough = false
@export var damage_value = 1
var target = 'enemy'

signal killed

func _ready() -> void:
	await get_tree().create_timer(timerTimeout).timeout
	emit_signal("killed")
	self.queue_free()

func _process(delta: float) -> void:
	if readyUp:
		self.position.x = lerp(self.position.x, self.position.x+direction.x,SPEED)
		self.position.y = lerp(self.position.y, self.position.y+direction.y,SPEED)
		SPEED += ACCEL


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group(target) and area.get_parent().dead != true:
		area.get_parent()._hit(damage_value)
		if !passthrough:
			emit_signal("killed")
			self.queue_free()

func _becomeReady():
	readyUp = true
