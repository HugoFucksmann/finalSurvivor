extends Item
class_name PassiveItem

@export var upgrades : Array[Stats]
var player_reference = preload("res://players/player.tscn")

func is_upgradable() -> bool:
	print("Checking is_upgradable, level: ", level, ", upgrades.size(): ", upgrades.size())
	return level < upgrades.size()  # Cambiado a < en lugar de <=
		
func upgrade_item():
	print("Upgrading item, current level: ", level)
	if not is_upgradable():
		print("Not upgradable")
		return 
	if player_reference == null:
		print("player_reference is null")
		return
		
	var upgrade = upgrades[level - 1]
	
	player_reference.max_health += upgrade.max_health
	player_reference.recovery += upgrade.recovery
	player_reference.armor += upgrade.armor
	player_reference.movement_speed += upgrade.movement_speed
	player_reference.might += upgrade.might
	player_reference.area += upgrade.area
	player_reference.magnet += upgrade.magnet
	player_reference.growth += upgrade.growth
	
	print("Upgrading item, new level: ", level + 1)
	
	level += 1
