extends Control

var hasCharPortrait = false
@export var dialog : Resource
var dialogIndex = 0
signal ended

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if dialog.character_script[dialogIndex] == null:
		hasCharPortrait = false
	else:
		hasCharPortrait = true
	$TextureRect/MarginContainer/RichTextLabel.visible_characters = 0
	if hasCharPortrait:
		$TextureRect/charPortrait.visible = true
	else:
		$TextureRect/charPortrait.visible = false
		
		$TextureRect/MarginContainer/RichTextLabel.text = dialog.scene_script[dialogIndex]


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		textMove()


func _on_txt_timer_timeout() -> void:
	if $TextureRect/MarginContainer/RichTextLabel.visible_ratio != 1:
		if $TextureRect/MarginContainer/RichTextLabel.visible_characters % 2 == 0:
			if len(dialog.voice_script)-1 >= dialogIndex:
				if dialog.voice_script[dialogIndex] != null:
					$AudioStreamPlayer.stream = dialog.voice_script[dialogIndex]
				$AudioStreamPlayer.playing = true
		$TextureRect/MarginContainer/RichTextLabel.visible_characters += 1
		$Txt_Timer.start()

func textMove():
	dialogIndex += 1
	
	if dialogIndex >= len(dialog.scene_script):
		if !dialog.is_choice:
			self.emit_signal("ended")
			self.queue_free()
			return 0
		else:
			var txt_box = load("res://dialogs/choice_textbox.tscn")
			var new = txt_box.instantiate()
			new.choice_names = dialog.choices
			new.choice_scenes = dialog.choice_scenes
			self.get_parent().add_child(new)
			self.queue_free()
			return 0
		
	if dialog.character_script[dialogIndex] == null:
		hasCharPortrait = false
	else:
		hasCharPortrait = true
		$TextureRect/charPortrait.texture = dialog.character_script[dialogIndex]
		
	if hasCharPortrait:
		$TextureRect/charPortrait.visible = true
	else:
		$TextureRect/charPortrait.visible = false
		
	$TextureRect/MarginContainer/RichTextLabel.visible_characters = 0
	$TextureRect/MarginContainer/RichTextLabel.text = dialog.scene_script[dialogIndex]
	$Txt_Timer.start()
