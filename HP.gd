extends Node2D
var grid
var HP
var HUD
var enemy = 0
var orbs
var orbsPressed = 0
var spell1
var spell2
var spell3
var gotTarget = 0
var explic

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	grid = get_tree().get_root().get_node("Battle/KinematicBody/GridMap")
	HP = get_tree().get_root().get_node("Battle/HUD/Player/HPValue")
	HUD = get_tree().get_root().get_node("Battle/HUD/Player")
	orbs = get_tree().get_root().get_node("Battle/HUD/Orbs")
	spell1 = get_tree().get_root().get_node("Battle/HUD/Orbs/Spell1")
	spell2 = get_tree().get_root().get_node("Battle/HUD/Orbs/Spell2")
	spell3 = get_tree().get_root().get_node("Battle/HUD/Orbs/Spell3")
	explic = get_tree().get_root().get_node("Battle/HUD/Explic")
	explic.hide()
	
	set_fixed_process(true)
func _fixed_process(delta):
	if grid.selected == 1:
		grid.isSelected.get_child(3).set_enabled(true)
		if grid.target == 1 and grid.isTarget.get_parent().get_name() == "Allies":
			grid.isTarget.get_child(3).set_enabled(true)
		elif grid.target == 1 and grid.isTarget.get_parent().get_name() == "Enemies":
			grid.isTarget.get_child(2).set_enabled(true)
		HP.set_text(str(grid.isSelected.getHp()))
		HUD.show()
		if grid.isSelected.getAttack() == 0:
			get_tree().get_root().get_node("Battle/HUD/Player/Attack").hide()
		else:
			get_tree().get_root().get_node("Battle/HUD/Player/Attack").show()
		if grid.isSelected.getMov() == 0:
			get_tree().get_root().get_node("Battle/HUD/Player/Move").hide()
		else:
			get_tree().get_root().get_node("Battle/HUD/Player/Move").show()
		if grid.isSelected.usedSpell == 1:
			orbs.hide()
			gotTarget = 0
			orbsPressed = 0
			
		if grid.isSelected.spellNumber == 3:
			spell1.get_child(2).set_text(str(grid.isSelected.get_child(2).charges[0]))
			spell2.get_child(2).set_text(str(grid.isSelected.get_child(2).charges[1]))
			spell3.get_child(2).set_text(str(grid.isSelected.get_child(2).charges[2]))
		if grid.isSelected.spellNumber == 2:
			spell1.get_child(2).set_text(str(grid.isSelected.get_child(2).charges[0]))
			spell2.get_child(2).set_text(str(grid.isSelected.get_child(2).charges[1]))
		if grid.isSelected.spellNumber == 1:
			spell1.get_child(2).set_text(str(grid.isSelected.get_child(2).charges[0]))	
	else:
		HUD.hide()
		orbs.hide()
		
	if enemy == 1:
		get_tree().get_root().get_node("Battle/HUD/Enemy").show()
	else:
		get_tree().get_root().get_node("Battle/HUD/Enemy").hide()
	
	
		
	
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_Move_pressed():
	grid.buttonMove = 1
	pass # replace with function body


func _on_Attack_pressed():
	gotTarget = 0
	grid.buttonAttack = 1
	pass # replace with function body


func _on_Pass_pressed():
	grid.isSelected.get_child(3).set_enabled(false)
	if grid.target == 1 and grid.isTarget.get_parent().get_name() == "Allies":
		grid.isTarget.get_child(3).set_enabled(false)
	elif grid.target == 1 and grid.isTarget.get_parent().get_name() == "Enemies":
		grid.isTarget.get_child(2).set_enabled(false)
	get_tree().get_root().get_node("Battle/Lights/Ok").set_enabled(false)
	get_tree().get_root().get_node("Battle/Lights/Nope").set_enabled(false)
	grid.isSelected.setMov(0)
	grid.isSelected.setAttack(0)
	grid.allies = grid.allies - 1
	grid.selected = 0
	enemy = 0
	pass # replace with function body


func _on_Orbs_pressed():
	grid.buttonSpell = 1
	if orbsPressed == 0:
		orbs.show()
		if grid.isSelected.spellNumber == 3:
			spell1.get_child(1).set_text(grid.isSelected.get_child(2).get_child(0).name)
			spell1.get_child(2).set_text(str(grid.isSelected.get_child(2).get_child(0).uses))
			spell2.get_child(1).set_text(grid.isSelected.get_child(2).get_child(1).name)
			spell2.get_child(2).set_text(str(grid.isSelected.get_child(2).get_child(1).uses))
			spell3.get_child(1).set_text(grid.isSelected.get_child(2).get_child(2).name)
			spell3.get_child(2).set_text(str(grid.isSelected.get_child(2).get_child(2).uses))
		if grid.isSelected.spellNumber == 2:
			spell3.hide()
			spell1.get_child(1).set_text(grid.isSelected.get_child(2).get_child(0).name)
			spell1.get_child(2).set_text(str(grid.isSelected.get_child(2).get_child(0).uses))
			spell2.get_child(1).set_text(grid.isSelected.get_child(2).get_child(1).name)
			spell2.get_child(2).set_text(str(grid.isSelected.get_child(2).get_child(1).uses))
		if grid.isSelected.spellNumber == 1:
			spell3.hide()
			spell2.hide()
			spell1.get_child(1).set_text(grid.isSelected.get_child(2).get_child(0).name)
			spell1.get_child(2).set_text(str(grid.isSelected.get_child(2).get_child(0).uses))
		if grid.isSelected.spellNumber == 0:
			spell3.hide()
			spell2.hide()
			spell1.hide()
			orbsPressed = 0
		if grid.isSelected.spellNumber >= 1 and grid.isSelected.get_child(2).get_child(0).special == 1 or grid.isSelected.get_child(2).get_child(0).special == 2:
			grid.targetAlly = 1
		elif grid.isSelected.spellNumber >= 2 and grid.isSelected.get_child(2).get_child(1).special == 1 or grid.isSelected.get_child(2).get_child(1).special == 2:
			grid.targetAlly = 1
		elif grid.isSelected.spellNumber == 3and grid.isSelected.get_child(2).get_child(2).special == 1 or grid.isSelected.get_child(2).get_child(2).special == 2:
			grid.targetAlly = 1
		orbsPressed = 1
	else:
		grid.buttonSpell = 0
		orbs.hide()
		orbsPressed = 0
		gotTarget = 0
	pass # replace with function body


func _on_Spell1_pressed():
	if gotTarget == 1:
		grid.isSelected.get_child(2).usespell(0)
		explic.hide()
		orbs.hide()
		orbsPressed = 0
		get_tree().get_root().get_node("Battle/HUD/Enemy").hide()
	pass # replace with function body


func _on_Spell2_pressed():
	if gotTarget == 1:
		grid.isSelected.get_child(2).usespell(1)
		explic.hide()
		orbs.hide()
		orbsPressed = 0
		get_tree().get_root().get_node("Battle/HUD/Enemy").hide()
	pass # replace with function body


func _on_Spell3_pressed():
	if gotTarget == 1:
		grid.isSelected.get_child(2).usespell(2)
		explic.hide()
		orbs.hide()
		orbsPressed = 0
		get_tree().get_root().get_node("Battle/HUD/Enemy").hide()
	pass # replace with function body


func _on_Spell1_mouse_enter():
	explic.get_child(1).set_text(grid.isSelected.get_child(2).get_child(0).explic)
	explic.show()
	pass # replace with function body


func _on_Spell1_mouse_exit():
	explic.hide()
	pass # replace with function body


func _on_Spell2_mouse_enter():
	explic.get_child(1).set_text(grid.isSelected.get_child(2).get_child(1).explic)
	explic.show()
	pass # replace with function body


func _on_Spell2_mouse_exit():
	explic.hide()
	pass # replace with function body


func _on_Spell3_mouse_enter():
	explic.get_child(1).set_text(grid.isSelected.get_child(2).get_child(2).explic)
	explic.show()
	pass # replace with function body


func _on_Spell3_mouse_exit():
	explic.hide()
	pass # replace with function body
