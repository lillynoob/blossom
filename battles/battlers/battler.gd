extends Control

@export var BattlerResource : Resource
var rig
var HP
var dead = false
@onready var ROOT = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent()
var last_parent

signal enemyKilled

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if BattlerResource.is_enemy == false:
		$ProgressBar.visible = false
	HP = BattlerResource.MAX_HP
	var rig_real = BattlerResource.rig.instantiate()
	add_child(rig_real)
	rig = rig_real
	$ProgressBar.max_value = BattlerResource.MAX_HP
	$ProgressBar.value = BattlerResource.MAX_HP
	$ProgressBar/Label.text = str(HP) + "/" + str(int($ProgressBar.max_value))
	last_parent = self.get_parent()

func _hit(dmg):
	HP -= dmg
	last_parent = self.get_parent()
	if HP <= 0:
		if BattlerResource.is_enemy:
			emit_signal("enemyKilled")
		HP = 0
		$ProgressBar.value = HP
		$ProgressBar/Label.text = str(HP) + "/" + str(int($ProgressBar.max_value))
		self.reparent(ROOT)
		dead = true
		rig.get_child(1).play('die')
		await rig.get_child(1).animation_finished
		if BattlerResource.is_enemy:
			self.queue_free()
	else:
		$ProgressBar.value = HP
		$ProgressBar/Label.text = str(HP) + "/" + str(int($ProgressBar.max_value))
		rig.get_child(1).play('hit')
		rig.get_child(1).queue('idle')

func _revive():
	if HP <= 0:
		self.reparent(last_parent)
		HP = BattlerResource.MAX_HP
		$ProgressBar.value = HP
		$ProgressBar/Label.text = str(HP) + "/" + str(int($ProgressBar.max_value))
		dead = false
		rig.get_child(1).play('idle')

func _heal(healing_amount):
	if HP > 0:
		HP += healing_amount
		if HP > BattlerResource.MAX_HP:
			HP = BattlerResource.MAX_HP
		$ProgressBar.value = HP
		$ProgressBar/Label.text = str(HP) + "/" + str(int($ProgressBar.max_value))
