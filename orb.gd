extends Node

var spell1ID
var spell2ID
var spell3ID
var charges = [0,0,0]
var spell = [0,0,0]


# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _ready():
	var childs = self.get_child_count()
	
	for x in range(childs):
		spell[x]= self.get_child(x)
		charges[x] = spell[x].uses
	pass


func usespell(i):
	if charges[i] >= 1:
		var ret = spell[i].hocuspocus() #usa o feitiço no primeiro slot da orb
		if ret != 0:
			charges[i] = charges[i] - 1
			get_tree().get_root().get_node("Battle/KinematicBody/GridMap").isTarget.get_child(0).get_node("AnimationPlayer").play("DamageTake", -1, 1, false)
			self.get_parent().get_child(0).get_node("AnimationPlayer").play("AttackSword", -1, 1, false)
			
	else: 
		print("Você não pode mais usar esse feitiço durante essa batalha")
