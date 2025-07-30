extends Node2D

var IS_MOVEMENT_OCCURING = false
@onready var moveButton = $Control/Buttons/VBoxContainer/Movement

@onready var playerField = $Control/Separator/PlayerField
@onready var playerRows 

@onready var enemyField = $Control/Separator/EnemyField
@onready var enemyRows

@export var row_count = 2
@export var space_counts = PackedInt32Array([1,1,1,1])
@export var party_spawn = [0,1]
@export var enemy_spawn = [1,0]
@export var enemy_list = ["res://battles/battlers/enemies/potty.tres"]

@onready var row = load('res://battles/setUp/row.tscn')
@onready var skillMenuPath = load("res://battles/setUp/skill_menu.tscn")
var rowIndex = 0

@onready var battleCursor = $battleCursor
var turnSpaceList = []
var turnIndex = 0
var currentMenuUp
var current_space
var carriedParty

var battleFinished = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(row_count):
		var spawn = row.instantiate()
		spawn.space_count = space_counts[i]
		playerField.add_child(spawn)
	
	for i in len(Globals.party):
		var new_battler = load("res://battles/battlers/battler.tscn").instantiate()
		new_battler.BattlerResource = Globals.party[i].battler
		new_battler.add_to_group("party")
		playerField.get_child(party_spawn[i].y).get_child(party_spawn[i].x).add_child(new_battler)
	
	for i in range(row_count):
		var spawn = row.instantiate()
		spawn.space_count = space_counts[i+row_count]
		enemyField.add_child(spawn)
	
	for i in len(enemy_spawn):
		var new_battler = load("res://battles/battlers/battler.tscn").instantiate()
		new_battler.BattlerResource = enemy_list[enemy_spawn[i].z]
		new_battler.connect("enemyKilled",_checkEnemyDeathStatus)
		new_battler.add_to_group("enemy")
		enemyField.get_child(enemy_spawn[i].y).get_child(enemy_spawn[i].x).add_child(new_battler)

	
	playerRows = playerField.get_children()
	enemyRows = enemyField.get_children()
	
	for i in range(playerField.get_child_count()):
		_begin_rows(playerRows, i)
		_begin_rows(enemyRows, i)
	
	_moveTurn()


func _get_all_in_row(rowToGet, i):
	for spaces in rowToGet[i].get_children():
		if spaces.get_child_count() > 0:
			print(spaces.get_child(0))
		print(spaces)
		spaces.connect("pressed", _on_space_pressed.bind(spaces))
		print(" ")

func _begin_rows(rowToBegin,i):
	for spaces in rowToBegin[i].get_children():
		spaces.connect("pressed", _on_space_pressed.bind(spaces))
		spaces.disabled = true
		turnSpaceList.append(spaces)

func _on_space_pressed(spaces) -> void:
	spaces.release_focus()
	for spacesToDisable in turnSpaceList:
		if spacesToDisable.get_parent().get_parent() == playerField:
			spacesToDisable.disabled = true
	carriedParty.reparent(spaces)
	carriedParty.position = Vector2(spaces.size.x/2,spaces.size.y/2)
	carriedParty.rig.get_child(1).play('idle')
	carriedParty.get_child(0).get_child(0).disabled = false
	IS_MOVEMENT_OCCURING = false
	_moveTurn()
	
func _moveTurn():
	current_space = (turnSpaceList[turnIndex])
	
	turnIndex += 1
	if turnIndex >= len(turnSpaceList):
		turnIndex = 0
	
	if current_space.get_child_count() <= 0:
		_moveTurn()
	elif current_space.get_child(0).is_in_group('enemy') and current_space.get_child(0).dead == false and !battleFinished:
		var rng = RandomNumberGenerator.new()
		rng = rng.randi_range(0,3)
		var newATK = current_space.get_child(0).BattlerResource.skills[rng].instantiate()
		if newATK.is_position_based_on_char:
			newATK.global_position = current_space.get_child(0).global_position
		newATK.target = "party"
		newATK.direction.x *= -1
		newATK.direction.y *= -1
		self.call_deferred('add_child',newATK)
		await newATK.killed
		_moveTurn()
		
	elif current_space.get_child(0).is_in_group('party') and current_space.get_child(0).dead == false and !battleFinished and !(current_space.get_child(0).is_in_group('spawn')):
		var newMenu = skillMenuPath.instantiate()
		if battleFinished:
			print('you should DIE. NOW!')
		moveButton.disabled = false
		newMenu.connect('finished', _call_attack)
		for i in range(4):
			newMenu.get_child(0).get_child(i).get_child(0).texture = current_space.get_child(0).BattlerResource.skills[i].instantiate().icon
			newMenu.get_child(0).get_child(i).get_child(0).name = current_space.get_child(0).BattlerResource.skills[i].instantiate().skill_name
			newMenu.get_child(0).get_child(i).skill = current_space.get_child(0).BattlerResource.skills[i]
		current_space.get_child(0).add_child(newMenu)
		currentMenuUp = newMenu
	elif current_space.get_child(0).is_in_group('spawn') and current_space.get_child(0).dead == false and !battleFinished and (current_space.get_child(0).is_in_group('party')):
		if current_space.get_child(0).is_in_group('attacker'):
			var rng = RandomNumberGenerator.new()
			rng = rng.randi_range(0,3)
			var newATK = current_space.get_child(0).BattlerResource.skills[rng].instantiate()
			if newATK.is_position_based_on_char:
				newATK.global_position = current_space.get_child(0).global_position
			newATK.target = "enemy"
			self.call_deferred('add_child',newATK)
			await newATK.killed
			_moveTurn()
		else:
			_moveTurn()
		
func _call_attack(option):
	if option == null:
		print("it's movin' time")
	else:
		moveButton.disabled = true
		var newATK = option.instantiate()
		if newATK.is_position_based_on_char:
			newATK.global_position = current_space.get_child(0).global_position
		newATK.target = "enemy"
		add_child(newATK)
		await newATK.killed
		_moveTurn()


func _on_move_pressed() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var viewport_size = get_viewport_rect().size
	if mouse_pos.x < 0 or mouse_pos.x > viewport_size.x or mouse_pos.y < 0 or mouse_pos.y > viewport_size.y:
		battleCursor.mouse_mode = false
	
	if (currentMenuUp != null):
		currentMenuUp._die_for_movement()
		await currentMenuUp.finish_move_ver
		battleCursor.position = Vector2(current_space.get_child(0).global_position.x,current_space.get_child(0).global_position.y-60)
	
	moveButton.disabled = true
	IS_MOVEMENT_OCCURING = true
	carriedParty = current_space.get_child(0)
	
	carriedParty.rig.get_child(1).play('picked')
	carriedParty.get_child(0).get_child(0).disabled = true
	
	if battleCursor.mouse_mode == true:
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(carriedParty, "global_position", Vector2(get_global_mouse_position().x,get_global_mouse_position().y+40), 0.75)
		await tween.finished
		
	carriedParty.reparent(battleCursor)
	carriedParty.position = Vector2(0,40)
	battleCursor.YOU_EXIST = true
	
	for spaces in turnSpaceList:
		if spaces.get_parent().get_parent() == playerField:
			spaces.disabled = false

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("movement") and !IS_MOVEMENT_OCCURING and $Control/Buttons/VBoxContainer/Movement.disabled == false:
		_on_move_pressed()
		
func _checkEnemyDeathStatus():
	var checkIfAllDead = true
	for i in row_count:
		for spaces in enemyField.get_child(i).get_children():
			if spaces.get_child_count() > 0:
				checkIfAllDead = false
	if checkIfAllDead:
		battleFinished = true
		print('yer done!')
		

func _spawn(spawn_skill):
	var new_battler = load("res://battles/battlers/battler.tscn").instantiate()
	new_battler.BattlerResource = spawn_skill.spawn_battler
	current_space.add_child(new_battler)
	new_battler.add_to_group("spawn")
	new_battler.add_to_group('party')
	if spawn_skill.attacker == true:
		new_battler.add_to_group('attacker')
	_on_move_pressed()
