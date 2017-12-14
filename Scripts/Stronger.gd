extends "res://Spells.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	 name = "Attack buff"
	 rang = 5
	 power = 2 #para testes, depois reduzir para 2 ou 3
	 special = 2
	 mode = 2#1 DEF 2 ATK 3 MOVE RANGE
	 uses = 1
	 explic = "Aumenta a força dos ataque de um aliado"