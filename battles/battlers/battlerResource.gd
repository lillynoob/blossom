extends Resource

class_name Battler

@export var name = "AURORA"
@export var is_enemy = true
@export var rig : PackedScene
@export var skills = [preload("res://battles/skills/attacks/BASIC_HAT.tscn"),preload("res://battles/skills/attacks/BASIC_HAT.tscn"),preload("res://battles/skills/attacks/BASIC_HAT.tscn"),preload("res://battles/skills/attacks/BASIC_HAT.tscn")]
@export var MAX_HP = 20
@export var MAX_MP = 10
var HP
