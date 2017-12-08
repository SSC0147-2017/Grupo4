extends GridMap

var turnNumber = 0
var turn = 0
var allies
var enemies
var obstructions
var selected = 0
var isSelected
var target = 0
var isTarget

var enemyTeam
var allyTeam
var obstructionTeam

var colMat = []

# class member variables go here, for example:
# var a = 2
# var b = "textvar"



func _ready():
	set_fixed_process(true)
	set_process_input(true)
	allies = get_tree().get_root().get_node("Battle/Allies").get_child_count()
	enemies = get_tree().get_root().get_node("Battle/Enemies").get_child_count()
	obstructions = get_tree().get_root().get_node("Battle/Obstructions").get_child_count()
	enemyTeam = get_tree().get_root().get_node("Battle/Enemies")
	allyTeam = get_tree().get_root().get_node("Battle/Allies")
	obstructionTeam = get_tree().get_root().get_node("Battle/Obstructions")
# Criando a matriz de poscisionamento.
	for x in range(11):
		colMat.append([])
		for y in range(11):
			colMat[x].append(0)
#Definindo a poscição inicial de cada unidade aliada e a pondo na matriz.
	setTeamOnMat(allyTeam,1)
#Definindo a poscição inicial de cada unidade inimiga e a pondo na matriz.
	setTeamOnMat(enemyTeam,2)
#Definindo a poscição inicial de cada obstruction e a pondo na matriz.
	setTeamOnMat(obstructionTeam,3)
#	for x in range(10):
#		for y in range(10):
#			print(colMat[x][y])
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func _input(event):
	if event.type == InputEvent.KEY:
		if event.is_action_pressed("ui_camera_N"):
			get_tree().get_root().get_node("Battle/Camera1").make_current()
			get_tree().get_root().get_node("Battle/DirectionalLight").set_enabled(true)
			get_tree().get_root().get_node("Battle/DirectionalLight1").set_enabled(false)
		if event.is_action_pressed("ui_camera_W"):
			get_tree().get_root().get_node("Battle/Camera2").make_current()
			get_tree().get_root().get_node("Battle/DirectionalLight").set_enabled(false)
			get_tree().get_root().get_node("Battle/DirectionalLight1").set_enabled(true)
		if event.is_action_pressed("ui_camera_E"):
			get_tree().get_root().get_node("Battle/Camera3").make_current()
			get_tree().get_root().get_node("Battle/DirectionalLight").set_enabled(true)
			get_tree().get_root().get_node("Battle/DirectionalLight1").set_enabled(false)
		if event.is_action_pressed("ui_camera_S"):
			get_tree().get_root().get_node("Battle/Camera4").make_current()
			get_tree().get_root().get_node("Battle/DirectionalLight").set_enabled(false)
			get_tree().get_root().get_node("Battle/DirectionalLight1").set_enabled(true)
			
			
	else:
		return 0

func _fixed_process(delta):
	if allies <= 0:
		print ("Ally Turn  : ",turnNumber + 1)
		turnNumber = turnNumber + 1
		allies = get_tree().get_root().get_node("Battle/Allies").get_child_count()
		for x in get_tree().get_root().get_node("Battle/Allies").get_children():
			x.setMov(1)
			x.setAttack(1)
		turn = 1
	if enemies <= 0:
		print ("Enemy Turn : ",turnNumber + 1)
		turnNumber = turnNumber + 1
		enemies = get_tree().get_root().get_node("Battle/Enemies").get_child_count()
		for x in get_tree().get_root().get_node("Battle/Enemies").get_children():
			x.setMov(1)
			x.setAttack(1)
		turn = 0
	if turn == 1:
		var vector = enemyTeam.get_children()
		for a in vector:
			enemyAI(a)
			
		
		
			
			
	
func attackEnemy(a):
	if dist(isSelected, isTarget) == 1 and isSelected.getAttack() == 1:
		isSelected.rotate(isTarget.getPosX(),isTarget.getPosZ())
		isTarget.receiveDmg(int(isSelected.getDmg()))
		isSelected.setAttack(0)
		print ("Vida agora: ",int(isTarget.getHp()))
		if int(isTarget.getHp()) <= 0:
			isTarget.queue_free()
			isTarget = 0
	else:
		print("Ataque falhou!")


func _on_KinematicBody_input_event( camera, event, click_pos, click_normal, shape_idx ):
	if selected == 1:
		if isSelected.getMov() == 1 and event.type == InputEvent.MOUSE_BUTTON and event.button_index == 1 and event.is_pressed():
			var posx = click_pos.x
			var posz = click_pos.z
			posx = calc_pos(posx)
			posz = calc_pos(posz)
			if distGrid(isSelected,posx,posz)>isSelected.getMovDist():
				return 0
			if(colMat[posx][posz]!=0):
				return 0
			
			colMat[isSelected.getPosX()][isSelected.getPosZ()]=0;
			isSelected.move_to(Vector3(posx*2-9,4.6,posz*2-9))
			isSelected.rotate(posx,posz)
			isSelected.setMov(0)
			isSelected.setPos(posx, posz)
			colMat[posx][posz]=1;
			
			if isSelected.get_parent() == allyTeam:
				allies = allies - 1
			else:
				enemies = enemies - 1
			selected = 0
			isSelected = 0
			
	
	pass # replace with function body
	
func calc_pos(pos):
	pos = floor(pos)
	pos  = pos / 2
	pos = pos + 5

	if floor(pos) == 10:
		return 9
	if floor(pos) == -1:
		return 0
	return floor(pos)

func limit_pos(pos):
	if floor(pos) == 10:
		return 9
	if floor(pos) == -1:
		return 0
	return floor(pos)
	
func dist(a, b):
	var d1 = abs(int(a.getPosX()) - int(b.getPosX()))
	var d2 = abs(int(a.getPosZ()) - int(b.getPosZ()))
	return d1 + d2
	
func distGrid(a,posX,posZ):
	var d1 = abs(int(a.getPosX()) - int(posX))
	var d2 = abs(int(a.getPosZ()) - int(posZ))
	return d1 + d2
	
	
func enemyAI(a): #cada inimigo executa essa rotina no turno dos inimigos
	#Percorre o vetor de aliados, vê se algum deles está a 1 quadrado de distância, se não, então procura o aliado mais próximo e se move na direção dele e tenta atacar novamente. 
	var vector = allyTeam.get_children() #TODO Percorrer o vetor de aliados
	isSelected = a
	selected = 1
	var menordist = 8000
	var hp
	var alvo
	var b
	for b in vector:
		var distancia = distGrid(b, a.getPosX(), a.getPosZ()) #se dois aliados tiverem à mesma distância, ele foca no que tiver menos vida
		if distancia < menordist:
				if distancia == menordist:
					if alvo.getHp() > b.getHp() && checkAllSides(b):
						alvo = b
				else:
					alvo = b
					menordist = distancia
	if distGrid(alvo, a.getPosX(), a.getPosZ()) == 1:
		isTarget = alvo
		target = 1
		attackEnemy("Inimigo atacou1")
		enemies = enemies - 1
		target = 0
		selected = 0
	else:
		enemyMove(a, alvo)
#		print(a.getPosX(), a.getPosZ()) 
		if distGrid(alvo, a.getPosX(), a.getPosZ()) == 1:
			isTarget = alvo
			target = 1
			attackEnemy("Inimigo atacou2")	
		enemies = enemies - 1
		target = 0
		selected = 0
func enemyMove(a, b):
	var ax
	var az
	var bx
	var bz
	ax = a.getPosX()
	bx = b.getPosX()
	az = a.getPosZ()
	bz = b.getPosZ()
	colMat[ax][az]=0
	var nx
	var nz
	var menordist=99
	menordist = distGrid(a, bx-1, bz)
	nx = limit_pos(bx-1)
	nz = limit_pos(bz)
	if distGrid(a, bx, bz+1) < menordist && colMat[bx][bz+1]==0:
		menordist = distGrid(a, bx, bz+1)
		nx = limit_pos(bx)
		nz = limit_pos(bz+1)
	if distGrid(a, bx+1, bz) < menordist && colMat[bx+1][bz]==0:
		menordist = distGrid(a, bx+1, bz)
		nx = limit_pos(bx+1)
		nz = limit_pos(bz)
	if distGrid(a, bx, bz-1) < menordist && colMat[bx][bz-1]==0:
		menordist = distGrid(a, bx, bz-1)
		nx = limit_pos(bx)
		nz = limit_pos(bz-1)
	if menordist <= a.getMovDist():
		ax = nx
		az = nz
	else: 
		var i = 0
		var token
		while i < a.getMovDist(): #CHECAR POR OBSTÁCULOS AQUI!
			token = 1
			if ax < nx:
				if token == 1 && colMat[ax+1][az]==0:
					ax = ax + 1
					token = 0
			if ax > nx:
				if token == 1 && colMat[ax-1][az]==0:
					ax = ax - 1
					token = 0
			if ax == nx:
				if az < nz :
					if token == 1 && colMat[ax][az+1]==0:
						az = az + 1
						token = 0
				if az > nz:
					if token == 1 && colMat[ax][az-1]==0:
						az = az - 1
						token = 0
			i = i + 1
	a.rotate(ax,az)
	a.move_to(Vector3(ax*2-9,4.6,az*2-9))
	colMat[ax][az]=1;
	a.setMov(0)
	a.setPos(ax, az)

func _on_Ally1_input_event( camera, event, click_pos, click_normal, shape_idx ):
	if turn == 0:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == 1 and event.is_pressed():
			if selected == 0:
				isSelected = get_tree().get_root().get_node("Battle/Allies/Ally1")
				selected = 1
	if turn == 1:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == 2 and event.is_pressed():
			if selected == 1:
				isTarget = get_tree().get_root().get_node("Battle/Allies/Ally1")
				target = 1
				attackEnemy("Inimigo atacou")
	pass # replace with function body

func _on_Enemy1_input_event( camera, event, click_pos, click_normal, shape_idx ):
	if turn == 1:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == 1 and event.is_pressed():
			if selected == 0:
				isSelected = get_tree().get_root().get_node("Battle/Enemies/Enemy1")
				selected = 1
				
	if turn == 0:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == 2 and event.is_pressed():
			if selected == 1:
				isTarget = get_tree().get_root().get_node("Battle/Enemies/Enemy1")
				target = 1
				attackEnemy("Aliado atacou")
	pass # replace with function body
# Retorna 1 caso o objeto tenha algum bloco ao lado não obstruido
func checkAllSides(a):
	var posX=a.getPosX()
	var posZ=a.getPosZ()
	if(colMat[posX+1][posZ]==0 or colMat[posX][posZ+1]==0 or colMat[posX][posZ-1]==0 or colMat[posX-1][posZ]==0):
		return 1
	return 0
#Coloca o time a na Matriz de colisões, deve ser posto no ready, x é o numero do time.
func setTeamOnMat(a,x):
	var pos1
	var pos2
	for x in a.get_children():
		pos1=x.get_translation().x
		pos2=x.get_translation().z
		pos1 = calc_pos(pos1)
		pos2 = calc_pos(pos2)
		x.move_to(Vector3(pos1*2-9,4.6,pos2*2-9))
		x.setPos(pos1,pos2)
		colMat[pos1][pos2]=2;