extends HBoxContainer

@export var space_count = 1
@onready var space_scene = load("res://battles/setUp/space.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(space_count):
		var spawn = space_scene.instantiate()
		add_child(spawn)
