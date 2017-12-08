extends Spatial

var posx  #Posicao atual
var posz 
var hp = 10 #Vida
var def = 0 #Defesa
var mov = 1 #Se pode mover
var movDist = 1 #Quanto ele pode se mover
var attack = 1 #Se pode atacar
var dmg = 1 #Dano do ataque

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _ready():
	
	pass
	
func setMov(value):
	mov = value

func getMov():
	return int(mov)
	

func getMovDist():
	return int(movDist)
	

func setAttack(value):
	attack = int(value)

func getAttack():
	return int(attack)
	
func getDmg():
	return int(dmg)
	
func getHp():
	return int(hp)

func setPos(x, z):
	posx = x
	posz = z

func getPosX():
	return int(posx)

func getPosZ():
	return int(posz)
	
func receiveDmg(dmg):
	var total = dmg - def
	if total > 0:
		hp = hp - total
			
func rotate(x,z):
	if(abs(x-posx)>abs(z-posz)):
		if(x>posx):
			set_rotation_deg(Vector3(0,90,0))
		if(x<posx):
			set_rotation_deg(Vector3(0,270,0))
	else:
		if(z>posz):
			set_rotation_deg(Vector3(0,0,0))
		if(z<posz):
			set_rotation_deg(Vector3(0,180,0))
	pass
