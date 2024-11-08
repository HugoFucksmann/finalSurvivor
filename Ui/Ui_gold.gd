extends Label


func _process(delta: float):
	text = "Gold: " + str(SavedData.gold)
