extends Node

var name
var rang
var power
var special
var mode #1 DEF 2 ATK 3 MOVE RANGE para buffs, número de chains para chainable spells (shockbolt)
var uses
var isSelected
var isTarget
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func hocuspocus():
	isSelected = get_tree().get_root().get_node("Battle/KinematicBody/GridMap").isSelected
	isTarget = get_tree().get_root().get_node("Battle/KinematicBody/GridMap").isTarget
	isSelected.get_child(0).get_node("AnimationPlayer").play("AttackSword", -1, 1, false)
	isTarget.get_child(0).get_node("AnimationPlayer").play("DamageTake", -1, 1, false)

	#primeiro checa se é special (Heal ou Buff, para AoE, Chain etc... ele checa depois)
	if special == 1: #heal
		spellAlly()
		
	if special == 2: #buff de ataque ou defesa ou range
		spellAlly()
		
	else:
		spellEnemy()
		if special == 3:
			var a = isTarget
			var b = get_tree().get_root().get_node("Battle/Enemies").get_children()
			for x in b:
				#if a != x:
				AoE(a, x, rang/2, power)
		#splash damage
		if special == 4:
			var a = isTarget
			var b = get_tree().get_root().get_node("Battle/Enemies").get_children()
			while mode > 0:
				for x in b:
					if a != x:
						AoE(a, x, rang, power/2)
						mode - 1
			#chaina pra outra pessoa
			#
#		pass

func spellEnemy():
	if get_tree().get_root().get_node("Battle/KinematicBody/GridMap").dist(isSelected, isTarget) <= rang and isSelected.getAttack() == 1:
		isSelected.rotate(isTarget.getPosX(),isTarget.getPosZ())
		isTarget.receiveDmg(int(power))
		isSelected.setAttack(0)
		print ("Vida agora: ",int(isTarget.getHp()))
		self.get_parent().get_parent().usedSpell = 1
		if int(isTarget.getHp()) <= 0:
			get_tree().get_root().get_node("Battle/KinematicBody/GridMap").colMat[isTarget.getPosX()][isTarget.getPosZ()] = 0
			isTarget.queue_free()
			isTarget = 0
	else:
		print("Ataque falhou!")
		
		
func AoE(base, a, subrang, subpower): #onde a é um inimigo, base é o quadrado onde o feitiço originalmente foi lançado, subrange e subpower são o alcance e o dano do splash
	if get_tree().get_root().get_node("Battle/KinematicBody/GridMap").dist(base, a) <= subrang:
		a.receiveDmg(int(subpower))
		isSelected.setAttack(0)
		print ("Vida agora: ",int(a.getHp()))
		self.get_parent().get_parent().usedSpell = 1
		if int(a.getHp()) <= 0:
			get_tree().get_root().get_node("Battle/KinematicBody/GridMap").colMat[a.getPosX()][a.getPosZ()] = 0
			a.queue_free()
			a = 0
	else:
		print("Splash Damage Falhou!")
	
func spellAlly(): #onde a é um aliado
	var a = get_tree().get_root().get_node("Battle/KinematicBody/GridMap").isTarget
	if get_tree().get_root().get_node("Battle/KinematicBody/GridMap").dist(isSelected, a) <= rang and isSelected.getAttack() == 1 and a.get_parent().get_name() == "Allies":
		isSelected.rotate(a.getPosX(),a.getPosZ())
		if special == 1:
			a.receiveHeal(int(power))
			print ("Vida agora: ",int(a.getHp()))
		if special == 2:
			a.buff(int(power), mode)
		isSelected.setAttack(0)
		self.get_parent().get_parent().usedSpell = 1
	else:
		print("Cura Buffa falhou!")