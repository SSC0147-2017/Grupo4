extends CanvasLayer

var path = ""

func _ready():
	
	pass

func fade_to(scn_path):
	self.path = scn_path
	get_node("AnimationPlayer").play("fade")

func change_scene():
	print(path)
	if path != "":
		get_tree().change_scene(path)