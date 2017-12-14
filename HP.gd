extends Node2D
var grid
var HP
var HUD
var enemy = 0
var orbs
var orbsPressed = 0

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	grid = get_tree().get_root().get_node("Battle/KinematicBody/GridMap")
	HP = get_tree().get_root().get_node("Battle/HUD/Player/HPValue")
	HUD = get_tree().get_root().get_node("Battle/HUD/Player")
	orbs = get_tree().get_root().get_node("Battle/HUD/Orbs")
	
	set_fixed_process(true)
func _fixed_process(delta):
	if grid.selected == 1:
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
	grid.buttonAttack = 1
	pass # replace with function body


func _on_Pass_pressed():
	grid.isSelected.setMov(0)
	grid.isSelected.setAttack(0)
	grid.allies = grid.allies - 1
	grid.selected = 0
	enemy = 0
	pass # replace with function body


func _on_Orbs_pressed():
	if orbsPressed == 0:
		orbs.show()
		orbsPressed = 1
	else:
		orbs.hide()
		orbsPressed = 0
	pass # replace with function body
