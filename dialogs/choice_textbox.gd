extends Control

@export var choice_names = ["Choice1","Choice2"]
var choice_scenes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureRect/MarginContainer/HBoxContainer/Button.text = str(" ") + choice_names[0]
	$TextureRect/MarginContainer/HBoxContainer/Button2.text = str(" ") + choice_names[1]
	$TextureRect/MarginContainer/HBoxContainer/Button.grab_focus()

func _on_button_focus_entered() -> void:
	$TextureRect/MarginContainer/HBoxContainer/Soul.position = Vector2($TextureRect/MarginContainer/HBoxContainer/Button.position.x,58.0)

func _on_button_2_focus_entered() -> void:
	$TextureRect/MarginContainer/HBoxContainer/Soul.position = Vector2($TextureRect/MarginContainer/HBoxContainer/Button2.position.x,58.0)


func _on_button_pressed() -> void:
	var txt_box = load("res://dialogs/textbox.tscn")
	var new = txt_box.instantiate()
	new.ended.connect(self.get_parent().get_parent().get_parent().get_parent().get_parent().player._text_box_ended)
	new.dialog = choice_scenes[0]
	self.get_parent().add_child(new)
	self.queue_free()


func _on_button_2_pressed() -> void:
	var txt_box = load("res://dialogs/textbox.tscn")
	var new = txt_box.instantiate()
	new.ended.connect(self.get_parent().get_parent().get_parent().get_parent().get_parent().player._text_box_ended)
	new.dialog = choice_scenes[1]
	self.get_parent().add_child(new)
	self.queue_free()
