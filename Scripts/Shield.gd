extends "res://Spells.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	 name = "Shield"
	 rang = 5
	 power = 1 #para propósitos de teste, depois diminuir para 1
	 special = 2
	 mode = 1#1 DEF 2 ATK 3 MOVE RANGE
	 uses = 1
	 explic = "Reduz o dano causado em um aliado"
