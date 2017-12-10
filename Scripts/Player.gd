extends Spatial
var team
var posx  #Posicao atual
var posz 
var hp = 10 #Vida
var def = 0 #Defesa
var mov = 1 #Se pode mover
var movDist = 3 #Quanto ele pode se mover
var attack = 1 #Se pode atacar
var dmg = 1 #Dano do ataque

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _ready():
	team=get_children()
	for x in team:
		if(x.get_name()=="Loli"):
			dmg=6
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
func move_in_path(colMat,nx,nz):
	var i = 0
	var token
	var prevz
	var prevx
	while i < movDist:
		prevx=posx
		prevz=posz
		token = 1
		colMat[prevx][prevz]=0;
		if prevx < nx:
			if token == 1 && colMat[prevx+1][prevz]==0:
				prevx = prevx + 1
				token = 0
		if prevx > nx:
			if token == 1 && colMat[prevx-1][prevz]==0:
				prevx = prevx - 1
				token = 0
		if prevz < nz :
			if token == 1 && colMat[prevx][prevz+1]==0:
				prevz = prevz + 1
				token = 0
		if prevz > nz:
			if token == 1 && colMat[prevx][prevz-1]==0:
				prevz = prevz - 1
				token = 0
		i = i + 1
		rotate(prevx,prevz)
		move_to(Vector3(prevx*2-9,4.6,prevz*2-9))
		colMat[prevx][prevz]=1
		posx=prevx
		posz=prevz
