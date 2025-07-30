extends TextureRect

var x_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_popUp()
	print(position.x)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _popUp():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(position.x,-36.0), 1)
