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
	if charges[i] > 1:
		spell[i].hocuspocus() #usa o feitiço no primeiro slot da orb
		charges[i] = charges[i] - 1
	else: 
		print("Você não pode mais usar esse feitiço durante essa batalha")
