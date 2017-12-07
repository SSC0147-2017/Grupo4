extends Spatial

var posx  #Posicao atual
var posz 

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func _ready():
	
	pass
	
	
func setPos(x, z):
	posx = x
	posz = z

func getPosX():
	return int(posx)

func getPosZ():
	return int(posz)
	
			
func calc_pos(pos):
	pos = floor(pos)
	pos  = pos / 2
	pos = pos + 5

	if floor(pos) == 10:
		return 9
	if floor(pos) == -1:
		return 0
	return floor(pos)
