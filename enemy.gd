extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var posx  #Posicao atual
var posz 
var hp = 10 #Vida
var def = 0 #Defesa
var mov = 1 #Se pode mover
var movDist = 1 #Quanto ele pode se mover
var attack = 1 #Se pode atacar
var dmg = 1 #Dano do ataque

func _ready():
	posx=get_translation().x
	posz=get_translation().z
	posx = calc_pos(posx)
	posz = calc_pos(posz)
	move_to(Vector3(posx*2-9,4.6,posz*2-9))
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
			
func calc_pos(pos):
	pos = floor(pos)
	pos  = pos / 2
	pos = pos + 5

	if floor(pos) == 10:
		return 9
	if floor(pos) == -1:
		return 0
	return floor(pos)

