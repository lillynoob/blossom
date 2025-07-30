extends Node2D

@export var skill_name = "Basic_ATK"
@export var icon : Texture
@export var spawn_battler = preload("res://battles/battlers/spawnables_PARTY/wall.tres")
var is_position_based_on_char = false
var target
@export var attacker = false

signal killed

func _ready() -> void:
	get_parent()._spawn(self)
