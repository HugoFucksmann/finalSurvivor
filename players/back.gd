extends Button

func _ready():
	visible = false

func _process(delta: float):
	if get_tree().paused == true and owner.health <= 0 and visible == false:
		visible = true


func _on_pressed() -> void:
	get_tree().paused = false
	SavedData.gold += owner.gold
	SavedData.set_and_save()
	get_tree().change_scene_to_file("res://sceenes/SkillTree.tscn")
