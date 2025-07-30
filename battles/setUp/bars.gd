extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in len(Globals.party):
		$HBoxContainer.get_child(i).get_child(0).text = Globals.party[i].name
		$HBoxContainer.get_child(i).get_child(1).max_value = Globals.party[i].battler.MAX_HP
		$HBoxContainer.get_child(i).get_child(2).max_value = Globals.party[i].battler.MAX_MP
		$HBoxContainer.get_child(i).get_child(1).value = $HBoxContainer.get_child(i).get_child(1).max_value
		$HBoxContainer.get_child(i).get_child(2).value = $HBoxContainer.get_child(i).get_child(2).max_value
	for i in range(4):
		if $HBoxContainer.get_child(i).get_child(0).text == "NAME":
			$HBoxContainer.get_child(i).visible = false
