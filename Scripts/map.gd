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

var buttonMove = 0
var buttonAttack = 0
var buttonSpell = 0

var colMat = []

var flarg = 0

var targetAlly = 0


# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func printMat():
	var x = 10
	while x > 0:
		print(colMat[x][0],colMat[x][1],colMat[x][2],colMat[x][3],colMat[x][4],colMat[x][5],colMat[x][6],colMat[x][7],colMat[x][8],colMat[x][9],colMat[x][10])
		x = x - 1
		
func wait():
	flarg = 0

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
	print(get_tree().get_root().get_node("Battle/Enemies").get_child_count())
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
	printMat()
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
		if event.is_action_pressed("ui_help"):
			if !get_tree().get_root().get_node("Battle/HelpPanel").is_visible():
				get_tree().get_root().get_node("Battle/HelpPanel").show()
			else:
				get_tree().get_root().get_node("Battle/HelpPanel").hide()
			
	else:
		return 0

func _fixed_process(delta):
	var a = get_tree().get_root().get_node("Battle/Allies").get_children()
	var b = get_tree().get_root().get_node("Battle/Enemies").get_children()

	flarg = 0
	for x in a:
		if x.moving == 1:
				flarg = 1
	for x in b:
		if x.moving == 1:
				flarg = 1
	
	if flarg == 0:
		if allies <= 0:
			print ("Ally Turn  : ",turnNumber + 1)
			turnNumber = turnNumber + 1
			get_tree().get_root().get_node("Battle/TurnPanel/AELabel").set_text("Inimigos")
			allies = get_tree().get_root().get_node("Battle/Allies").get_child_count()
			for x in get_tree().get_root().get_node("Battle/Allies").get_children():
				x.setMov(1)
				x.setAttack(1)
				x.usedSpell = 0
			turn = 1
		if enemies <= 0:
			print ("Enemy Turn : ",turnNumber + 1)
			turnNumber = turnNumber + 1
			get_tree().get_root().get_node("Battle/TurnPanel/AELabel").set_text("Aliados")
			enemies = get_tree().get_root().get_node("Battle/Enemies").get_child_count()
			for x in get_tree().get_root().get_node("Battle/Enemies").get_children():
				x.setMov(1)
				x.setAttack(1)
			turn = 0
		get_tree().get_root().get_node("Battle/TurnPanel/TurnLabel").set_text("Turno " + str(floor(turnNumber/2+1)))
		if turn == 1:
			var vector = enemyTeam.get_children()
			for a in vector:
				if flarg == 0:
					enemyAI(a)
		if get_tree().get_root().get_node("Battle/Enemies").get_child_count() == 0:
			get_tree().get_root().get_node("Battle/WinLosePanel").show()
			get_tree().get_root().get_node("Battle/WinLosePanel/WinLoseLabel").set_text("VITÓRIA!")
			get_tree().get_root().get_node("Battle/WinLosePanel/Return").set_text("Terminar batalha.")
		if get_tree().get_root().get_node("Battle/Allies").get_child_count() == 0:
			get_tree().get_root().get_node("Battle/WinLosePanel").show()
			get_tree().get_root().get_node("Battle/WinLosePanel/WinLoseLabel").set_text("DERROTA!")
			get_tree().get_root().get_node("Battle/WinLosePanel/Return").set_text("Voltar para o menu.")
	
	
func attackEnemy(a):
	if dist(isSelected, isTarget) <= isSelected.getAttackDist() and isSelected.getAttack() == 1 and isTarget.get_parent().get_name() == "Enemies":
		isSelected.rotate(isTarget.getPosX(),isTarget.getPosZ())
		isTarget.receiveDmg(int(isSelected.getDmg()))
		isSelected.setAttack(0)
		isSelected.anim.play("AttackSword", -1, 1, false)
		isTarget.rotate(isSelected.getPosX(), isSelected.getPosZ())
		isTarget.anim.play("DamageTake", -1, 1, false)
		print ("Vida agora: ",int(isTarget.getHp()))
		if int(isTarget.getHp()) <= 0:
			get_tree().get_root().get_node("Battle/HUD").enemy = 0
			colMat[isTarget.getPosX()][isTarget.getPosZ()] = 0
			isTarget.queue_free()
			isTarget = 0
	else:
		print("Ataque falhou!")
		
func attackEnemyAI(a, b):
	if dist(a, b) <= a.getAttackDist() and a.getAttack() == 1 and isTarget.get_parent().get_name() == "Allies":
		a.rotate(b.getPosX(),b.getPosZ())
		b.receiveDmg(int(a.getDmg()))
		a.setAttack(0)
		a.anim.play("AttackSword", -1, 1, false)
		b.rotate(a.getPosX(), a.getPosZ())
		b.anim.play("DamageTake", -1, 1, false)
		print ("Vida agora: ",int(b.getHp()))
		if int(b.getHp()) <= 0:
			colMat[b.getPosX()][b.getPosZ()] = 0
			b.queue_free()
			b = 0
	else:
		print("Ataque falhou!")


func _on_KinematicBody_input_event( camera, event, click_pos, click_normal, shape_idx ):
	if selected == 1 and buttonMove == 1:
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
			isSelected.move_in_path(colMat,posx,posz)
			isSelected.setMov(0)
			buttonMove = 0
	

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
	var i = 0
	var token
	var prevz=a.getPosZ()
	var prevx=a.getPosX()
	while (i < a.getMovDist())&&(prevx!=posX || prevz!=posZ):
		token = 1
		if prevx < posX:
			if token == 1 && colMat[prevx+1][prevz]==0:
				prevx = prevx + 1
				token = 0
		if prevx > posX:
			if token == 1 && colMat[prevx-1][prevz]==0:
				prevx = prevx - 1
				token = 0
		if prevz < posZ :
			if token == 1 && colMat[prevx][prevz+1]==0:
				prevz = prevz + 1
				token = 0
		if prevz > posZ:
			if token == 1 && colMat[prevx][prevz-1]==0:
				prevz = prevz - 1
				token = 0
		i = i + 1
	if (prevx==posX && prevz==posZ):
		return i
	else:
		return 99
	
	
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
	isTarget = alvo
	isSelected.myTarget = alvo
	target = 1
	enemyMove(a, alvo)
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
	var nx = limit_pos(bx-1)
	var nz = limit_pos(bz)
	var menordist=a.getMovDist()
	if distGrid(a, bx-1, bz) < menordist && colMat[bx-1][bz]==0:
		menordist = distGrid(a, bx-1, bz)
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
	ax = nx
	az = nz
	a.rotate(ax,az)
	a.move_in_path(colMat,ax,az)
	#colMat[ax][az]=1;
	a.setMov(0)
	#a.setPos(ax, az)
	

func _on_Ally1_input_event( camera, event, click_pos, click_normal, shape_idx ):
	if turn == 0:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == 1 and event.is_pressed():
			if selected == 0:
				isSelected = get_tree().get_root().get_node("Battle/Allies/Ally1")
				selected = 1
	if turn == 0 and targetAlly == 1:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == 1 and event.is_pressed():
			if selected == 1:
				isTarget = get_tree().get_root().get_node("Battle/Allies/Ally1")
				target = 1
				get_tree().get_root().get_node("Battle/HUD").gotTarget = 1
	pass # replace with function body

func _on_Enemy1_input_event( camera, event, click_pos, click_normal, shape_idx ):
	get_tree().get_root().get_node("Battle/HUD/Enemy/EnemyHPValue").set_text(str(get_tree().get_root().get_node("Battle/Enemies/Enemy1").getHp()))
	get_tree().get_root().get_node("Battle/HUD/Enemy/EnemyInfoText2").set_text(str(get_tree().get_root().get_node("Battle/Enemies/Enemy1").get_child(0).get_name()))
	get_tree().get_root().get_node("Battle/HUD").enemy = 1
#	get_tree().get_root().get_node("Battle/HUD/Enemy").show()
	
	if turn == 1:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == 1 and event.is_pressed():
			if selected == 0:
				isSelected = get_tree().get_root().get_node("Battle/Enemies/Enemy1")
				selected = 1
				
	if turn == 0 and buttonAttack == 1:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == 1 and event.is_pressed():
			if selected == 1:
				isTarget = get_tree().get_root().get_node("Battle/Enemies/Enemy1")
				target = 1
				attackEnemy("Aliado atacou")
			buttonAttack = 0
	elif turn == 0 and buttonSpell == 1:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == 1 and event.is_pressed():
			if selected == 1:
				isTarget = get_tree().get_root().get_node("Battle/Enemies/Enemy1")
				target = 1
				get_tree().get_root().get_node("Battle/HUD").gotTarget = 1
	pass # replace with function body
	
func _on_Enemy2_input_event( camera, event, click_pos, click_normal, shape_idx ):
	get_tree().get_root().get_node("Battle/HUD/Enemy/EnemyHPValue").set_text(str(get_tree().get_root().get_node("Battle/Enemies/Enemy2").getHp()))
	get_tree().get_root().get_node("Battle/HUD/Enemy/EnemyInfoText2").set_text(str(get_tree().get_root().get_node("Battle/Enemies/Enemy2").get_child(0).get_name()))
	get_tree().get_root().get_node("Battle/HUD").enemy = 1
	if turn == 1:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == 1 and event.is_pressed():
			if selected == 0:
				isSelected = get_tree().get_root().get_node("Battle/Enemies/Enemy2")
				selected = 1
				
	if turn == 0 and buttonAttack == 1:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == 1 and event.is_pressed():
			if selected == 1:
				isTarget = get_tree().get_root().get_node("Battle/Enemies/Enemy2")
				target = 1
				attackEnemy("Aliado atacou")
			buttonAttack = 0
	elif turn == 0 and buttonSpell == 1:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == 1 and event.is_pressed():
			if selected == 1:
				isTarget = get_tree().get_root().get_node("Battle/Enemies/Enemy2")
				target = 1
				get_tree().get_root().get_node("Battle/HUD").gotTarget = 1
	pass # replace with function body
	
func _on_Enemy3_input_event( camera, event, click_pos, click_normal, shape_idx ):
	get_tree().get_root().get_node("Battle/HUD/Enemy/EnemyHPValue").set_text(str(get_tree().get_root().get_node("Battle/Enemies/Enemy3").getHp()))
	get_tree().get_root().get_node("Battle/HUD/Enemy/EnemyInfoText2").set_text(str(get_tree().get_root().get_node("Battle/Enemies/Enemy3").get_child(0).get_name()))
	get_tree().get_root().get_node("Battle/HUD").enemy = 1
	if turn == 1:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == 1 and event.is_pressed():
			if selected == 0:
				isSelected = get_tree().get_root().get_node("Battle/Enemies/Enemy3")
				selected = 1
				
	if turn == 0 and buttonAttack == 1:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == 1 and event.is_pressed():
			if selected == 1:
				isTarget = get_tree().get_root().get_node("Battle/Enemies/Enemy3")
				target = 1
				attackEnemy("Aliado atacou")
			buttonAttack = 0
	elif turn == 0 and buttonSpell == 1:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == 1 and event.is_pressed():
			if selected == 1:
				isTarget = get_tree().get_root().get_node("Battle/Enemies/Enemy3")
				target = 1
				get_tree().get_root().get_node("Battle/HUD").gotTarget = 1
	pass # replace with function body


func _on_Enemy4_input_event( camera, event, click_pos, click_normal, shape_idx ):
	get_tree().get_root().get_node("Battle/HUD/Enemy/EnemyHPValue").set_text(str(get_tree().get_root().get_node("Battle/Enemies/Enemy4").getHp()))
	get_tree().get_root().get_node("Battle/HUD/Enemy/EnemyInfoText2").set_text(str(get_tree().get_root().get_node("Battle/Enemies/Enemy4").get_child(0).get_name()))
	get_tree().get_root().get_node("Battle/HUD").enemy = 1
	if turn == 1:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == 1 and event.is_pressed():
			if selected == 0:
				isSelected = get_tree().get_root().get_node("Battle/Enemies/Enemy4")
				selected = 1
				
	if turn == 0 and buttonAttack == 1:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == 1 and event.is_pressed():
			if selected == 1:
				isTarget = get_tree().get_root().get_node("Battle/Enemies/Enemy4")
				target = 1
				attackEnemy("Aliado atacou")
			buttonAttack = 0
	elif turn == 0 and buttonSpell == 1:
		if event.type == InputEvent.MOUSE_BUTTON and event.button_index == 1 and event.is_pressed():
			if selected == 1:
				isTarget = get_tree().get_root().get_node("Battle/Enemies/Enemy4")
				target = 1
				get_tree().get_root().get_node("Battle/HUD").gotTarget = 1
	pass # replace with function body
	
	
	
# Retorna 1 caso o objeto tenha algum bloco ao lado não obstruido
func checkAllSides(a):
	var posX=a.getPosX()
	var posZ=a.getPosZ()
	if(colMat[posX+1][posZ]==0 or colMat[posX][posZ+1]==0 or colMat[posX][posZ-1]==0 or colMat[posX-1][posZ]==0):
		return 1
	return 0
#Coloca o time a na Matriz de colisões, deve ser posto no ready, x é o numero do time.
func setTeamOnMat(a,n):
	var pos1
	var pos2
	for x in a.get_children():
		pos1=x.get_translation().x
		pos2=x.get_translation().z
		pos1 = calc_pos(pos1)
		pos2 = calc_pos(pos2)
		x.move_to(Vector3(pos1*2-9,4.6,pos2*2-9))
		x.setPos(pos1,pos2)
		colMat[pos1][pos2]=n;





