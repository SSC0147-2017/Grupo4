extends ColorFrame

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_MenuButton_pressed():
	Transition.fade_to("res://MainMenu.tscn")
	pass # replace with function body
