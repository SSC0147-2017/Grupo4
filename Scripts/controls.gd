extends VBoxContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_MenuButton_pressed():
	get_tree().change_scene("res://Battle.tscn")
	pass # replace with function body


func _on_MenuButton2_pressed():
	get_tree().quit()
	pass # replace with function body