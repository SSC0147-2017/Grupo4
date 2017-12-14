extends Node

var rang
var power
var special
var mode #1 DEF 2 ATK 3 MOVE RANGE
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
	#primeiro checa se é special (Heal ou Buff, para AoE, Chain etc... ele checa depois)
	if special == 1: #heal
		spellAlly()
		pass
	if special == 2: #buff de ataque ou defesa ou range
		spellAlly()
		pass
	else:
		spellEnemy()
		#em seguida, função checa se o alvo tá no range do spell
		#se sim, dá o damage
		if special == 3:
#			AoE()
		#splash damage
			pass
		if special == 4:
			#chaina pra outra pessoa
			pass
			#
		pass

func spellEnemy():
	if get_tree().get_root().get_node("Battle/KinematicBody/GridMap").dist(isSelected, isTarget) <= rang and isSelected.getAttack() == 1:
		isSelected.rotate(isTarget.getPosX(),isTarget.getPosZ())
		isTarget.receiveDmg(int(power))
		isSelected.setAttack(0)
		print ("Vida agora: ",int(isTarget.getHp()))
		if int(isTarget.getHp()) <= 0:
			get_tree().get_root().get_node("Battle/KinematicBody/GridMap").colMat[isTarget.getPosX()][isTarget.getPosZ()] = 0
			isTarget.queue_free()
			isTarget = 0
	else:
		print("Ataque falhou!")
		
		
func AoE(base, a, subrang, subpower): #onde a é um inimigo, base é o quadrado onde o feitiço originalmente foi lançado, subrange e subpower são o alcance e o dano do splash
	if dist(base, a) <= subrang == 1:
		a.receiveDmg(int(subpower))
		print ("Vida agora: ",int(a.getHp()))
		if int(a.getHp()) <= 0:
			get_tree().get_root().get_node("Battle/KinematicBody/GridMap").colMat[a.getPosX()][a.getPosZ()] = 0
			a.queue_free()
			a = 0
	else:
		print("Ataque falhou!")
	
func spellAlly(): #onde a é um aliado
	var a = get_tree().get_root().get_node("Battle/KinematicBody/GridMap").isTarget
	if dist(isSelected, a) <= rang and isSelected.getAttack() == 1 and a.get_parent().get_name() == "Allies":
		isSelected.rotate(a.getPosX(),a.getPosZ())
		if special == 1:
			a.receiveHeal(int(power))
			print ("Vida agora: ",int(a.getHp()))
		if special == 2:
			a.buff(int(power), mode)
		isSelected.setAttack(0)
	else:
		print("Cura Buffa falhou!")