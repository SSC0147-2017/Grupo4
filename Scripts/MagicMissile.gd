extends "res://Spells.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready(): #Instakill Single Use for test purposes
	name = "Magic Missiles"
	rang = 8 #Final range = 8
	power = 1 #Final power = 1
	special = 0
	mode = 0
	uses = 5 #Final 5
	explic = "Ataque mágico fraco, mas com longo alcance (8 quadrados)"
