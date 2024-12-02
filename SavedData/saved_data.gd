extends Node2D
 
var gold = 2500
var skill_tree = []
 
const PATH = "user://player_data.cfg"
@onready var config = ConfigFile.new()
 
func _ready():
	load_data()
	set_and_save()
 
func save_data():
	config.save(PATH)
 
func load_data():
	if config.load(PATH) != OK:
		set_and_save()
 
	gold = config.get_value("Player", "gold", 2500)
	skill_tree = config.get_value("Player", "skill_tree", [])
 
func set_data():
	config.set_value("Player", "gold", gold)
	config.set_value("Player", "skill_tree", skill_tree)
 
func set_and_save():
	set_data()
	save_data()
