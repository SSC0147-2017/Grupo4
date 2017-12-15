extends Spatial
var team
var posx  #Posicao atual
var posz
var maxhp = 10 
var hp = 10 #Vida
var def = 0 #Defesa
var mov = 1 #Se pode mover
var movDist = 3 #Quanto ele pode se mover
var attack = 1 #Se pode atacar
var attackDist = 1
var dmg = 3 #Dano do ataque

var moving = 0
var movStart = 0
var oDirX
var oDirZ
var dirX
var dirZ
var sec = 0

var myTarget
var usedSpell = 0 


var it = 0
var token
var prevz
var prevx
var nx
var nz
var anim
var spellNumber = 0

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _ready():
	set_fixed_process(true)
	team=get_children()
	for x in team:
		if(x.get_name()=="Loli"):
			dmg=2
		if x.get_name() == "Criminal":
			 movDist = movDist - 1
	anim = self.get_child(0).get_node("AnimationPlayer")
	anim.play("Idle", -1, 1, false)
	if self.get_child_count() == 4:
		spellNumber = self.get_child(2).get_child_count()
	pass

func _fixed_process(delta):
	if moving == 1 and sec > 0:
		move(Vector3(dirX,0,dirZ) * delta * 2/sqrt(pow(dirX, 2) + pow(dirZ, 2)))
		sec = sec - delta
	if sec <= 0:
		moving = 0
	if movStart == 1 and moving == 0:
		prevx=posx
		prevz=posz
		token = 1
		var map = get_tree().get_root().get_node("Battle/KinematicBody/GridMap")
		map.colMat[prevx][prevz]=0;
		if prevx < nx:
			if token == 1 && map.colMat[prevx+1][prevz]==0:
				prevx = prevx + 1
				token = 0
		if prevx > nx:
			if token == 1 && map.colMat[prevx-1][prevz]==0:
				prevx = prevx - 1
				token = 0
		if prevz < nz :
			if token == 1 && map.colMat[prevx][prevz+1]==0:
				prevz = prevz + 1
				token = 0
		if prevz > nz:
			if token == 1 && map.colMat[prevx][prevz-1]==0:
				prevz = prevz - 1
				token = 0
		dirX = prevx - posx
		dirZ = prevz - posz
		var Distancia = sqrt(pow(dirX, 2) + pow(dirZ, 2))
		wait(Distancia)
		moving = 1
		rotate(prevx,prevz)
		it = it + 1
		if self.get_parent() == get_tree().get_root().get_node("Battle/Allies"):
			map.colMat[prevx][prevz]=1
		else:
			map.colMat[prevx][prevz]=2
		posx=prevx
		posz=prevz
		if token == 1 or it >= movDist + 1:
			it = 0
			movStart = 0
			anim.play("Idle", -1, 1, false)
			if map.turn == 1 and map.dist(map.isSelected, map.isTarget) <= map.isSelected.getAttackDist():
				map.attackEnemyAI(self, myTarget)
			
	
		
func getAttackDist():
	return attackDist
		
func wait(s):
	sec = s
	return s
	
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
			
func receiveHeal(heal):
		if hp + heal <= maxhp:
			hp = hp + heal
		else:
			hp = maxhp
		
		
func buff(power, mode):
	if mode == 1:
		def = def + power
	elif mode == 2:
		dmg = dmg + power
	else:
		movDist = movDist + power
	
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
	
func move_in_path(colMat,x,z):
	nx = x
	nz = z
	oDirX = posx
	oDirZ = posz
	anim.play("Walk_blocking", -1, 1, false)
	movStart = 1
	
