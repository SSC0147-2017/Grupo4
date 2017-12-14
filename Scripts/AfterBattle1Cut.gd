extends Panel

var position = 0
var delimiter = "|"

func _ready():
	var file = File.new()
	file.open("res://Text//After.txt", file.READ)
	file.seek(position)
	var nextLine = file.get_csv_line(delimiter)
	readConfig(file, nextLine)
	file.close()
	pass

func _on_Next_pressed():
	var file = File.new()
	file.open("res://Text//After.txt", file.READ)
	file.seek(position)
	var nextLine = file.get_csv_line(delimiter)
	if str(nextLine[0]).match("start_config"):
		readConfig(file, nextLine)
	elif file.eof_reached():
		file.close()
		var scene = preload("res://Battle.tscn")
		get_tree().change_scene("res://Battle.tscn")
	else:
		readNewText(file, nextLine)
	pass

func readNewText(var file, var nextLine):
	print(str("TEXT: " + nextLine[0]))
	get_tree().get_root().get_node("Background/TextPanel/Text").set_text(str(nextLine[0]))
	position = file.get_pos()
	print("TEXT: " + str(position))
	pass
	
func readConfig(var file, var nextLine):
	print(str("CONFIG: " + nextLine[0]))
	while(!str(nextLine[0]).match("end_config")):
		if str(nextLine[0]).match("left"):
			nextLine = file.get_csv_line(delimiter)
			print("2nd: " + str(nextLine[0]))
			get_tree().get_root().get_node("Background/char1").set_texture(load("res://Source//Cutscenes//sprites//" + nextLine[0] + ".png"))
		if str(nextLine[0]).match("right"):
			nextLine = file.get_csv_line(delimiter)
			print("3rd: " + str(nextLine[0]))
			get_tree().get_root().get_node("Background/char2").set_texture(load("res://Source//Cutscenes//sprites//" + nextLine[0] + ".png"))
		if str(nextLine[0]).match("bg"):
			nextLine = file.get_csv_line(delimiter)
			print(str(get_tree().get_root().get_node("Background").set_texture(load("res://Source//Cutscenes//bg//" + nextLine[0] + ".png"))))
			get_tree().get_root().get_node("Background").set_texture(load("res://Source//Cutscenes//bg//" + nextLine[0] + ".png"))
		nextLine = file.get_csv_line(delimiter)
	nextLine = file.get_csv_line(delimiter)
	position = file.get_pos()
	print("CONFIG: " + str(position))
	readNewText(file, nextLine)
	pass