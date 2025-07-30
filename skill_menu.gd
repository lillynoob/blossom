extends Node2D

var toggle = false
@onready var options = $Path2D.get_children()
var index = 0
@onready var skillLabel = $MarginContainer/Label
# Called when the node enters the scene tree for the first time.

signal finished(option)
signal finish_move_ver

func _ready() -> void:
	skillLabel.text = options[index].get_child(0).name
	self.scale = Vector2.ZERO
	
	var tween2 = get_tree().create_tween()
	tween2.set_trans(Tween.TRANS_CUBIC)
	tween2.set_ease(Tween.EASE_OUT)
	tween2.tween_property(self, "scale", Vector2(1,1), 0.5)
	
	await tween2.finished
	toggle = true
	$rightButton.disabled = false
	$leftButton.disabled = false
	$mouseSelect.disabled = false
	_changeSizes()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if toggle and Input.is_action_just_pressed("ui_accept"):
		toggle = false
		_select()
	
	if Input.is_action_just_pressed("ui_right") and toggle:
		_right()
	
	if Input.is_action_just_pressed("ui_left") and toggle:
		_left()

	if !toggle:
		$leftButton.disabled = true
		$rightButton.disabled = true
		$mouseSelect.disabled = true

func _on_timer_timeout() -> void:
	toggle = true
	$leftButton.disabled = false
	$rightButton.disabled = false
	$mouseSelect.disabled = false
	
func _changeSizes():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(options[index].get_child(0), "scale", Vector2(1.2,1.2), 0.5)
	options[index].get_child(0).modulate = Color("#ffffff")
	for option in options:
		if option != options[index]:
			var tween2 = get_tree().create_tween()
			tween2.set_trans(Tween.TRANS_CUBIC)
			tween2.set_ease(Tween.EASE_OUT)
			tween2.tween_property(option.get_child(0), "scale", Vector2(0.8,0.8), 0.5)
			option.get_child(0).modulate = Color("#8f8f8f")
	skillLabel.text = options[index].get_child(0).name

func _select():
	toggle = false
	emit_signal('finished',options[index].skill)
	var tween2 = get_tree().create_tween()
	tween2.set_trans(Tween.TRANS_CUBIC)
	tween2.set_ease(Tween.EASE_OUT)
	tween2.tween_property(options[index].get_child(0), "scale", Vector2(1.5,1.5), 0.2)
	
	await tween2.finished
	
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(options[index].get_child(0), "scale", Vector2(0,0), 0.4)
	
	await tween.finished
	
	var tween3 = get_tree().create_tween()
	tween3.set_trans(Tween.TRANS_CUBIC)
	tween3.set_ease(Tween.EASE_OUT)
	tween3.tween_property(self, "scale", Vector2.ZERO, 0.5)
	
	await tween3.finished
	
	self.queue_free()

func _die_for_movement():
	var tween3 = get_tree().create_tween()
	tween3.set_trans(Tween.TRANS_CUBIC)
	tween3.set_ease(Tween.EASE_OUT)
	tween3.tween_property(self, "scale", Vector2.ZERO, 0.25)
	
	await tween3.finished
	
	emit_signal("finish_move_ver")
	self.queue_free()

func _left():
	for paths in $Path2D.get_children():
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(paths, "progress_ratio", paths.progress_ratio+0.25, 0.5)
	toggle = false
	$Timer.start()
	index -= 1
	if index < 0:
		index = 3
	_changeSizes()

func _right():
	for paths in $Path2D.get_children():
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(paths, "progress_ratio", paths.progress_ratio-0.25, 0.5)
	toggle = false
	$Timer.start()
	index += 1
	if index >= len(options):
		index = 0
	_changeSizes()

func _on_left_button_pressed() -> void:
	_left()

func _on_right_button_pressed() -> void:
	_right()

func _on_mouse_select_pressed() -> void:
	toggle = false
	_select()
